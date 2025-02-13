variable "lambda_runtime" {}
variable "lambda_zip_file" {}
variable "lambda_name" {}
variable "microservice" {}
variable "api_id" {}
variable "api_stage" {}

data "aws_caller_identity" "current" {}

### IAM Role for Lambda
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

### Lambda Function
resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.microservice}-${var.lambda_name}"
  runtime       = var.lambda_runtime
  handler       = "index.handler"
  filename      = var.lambda_zip_file
  role          = aws_iam_role.lambda_role.arn  
}

### API Gateway Integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda_function.invoke_arn
  connection_type  = "INTERNET"
}

### API Gateway Permission for Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${var.api_id}/*/GET/${var.lambda_name}"
}

### Output API Gateway URL
output "api_gateway_url" {
  value       = "https://${var.api_id}.execute-api.us-east-1.amazonaws.com/${var.api_stage}/${var.lambda_name}"
  description = "API Gateway URL for the Lambda Function"
}

### Terraform Backend
terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-878795645"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
