variable "lambda_runtime" {}
variable "lambda_zip_file" {}
variable "lambda_name" {}
variable "api_id" {}
variable "api_stage" {}

###LAMBDA
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "lambda_basic_execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
  runtime       = var.lambda_runtime
  handler       = "main.lambda_handler"
  filename      = var.lambda_zip_file
  role          = aws_iam_role.lambda_role.arn  
}

###API-GATEWAY
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = var.api_id 
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda_function.invoke_arn
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = var.api_id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_id}/*/*"
}

###OUTPUTS
output "api_gateway_url" {
  value = aws_apigatewayv2_api.lambda_api.api_endpoint
  description = "URL do API Gateway"
}

###BACKEND
terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-878795645"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
