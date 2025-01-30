provider "aws" {
  region = "us-east-1"
}

# Criar Role para a Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

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

# Criar Policy para Logs no CloudWatch
resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda_logs"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Criar a AWS Lambda
resource "aws_lambda_function" "lambda_function" {
  function_name = "hello-world-${var.environment}"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"

  filename         = var.lambda_zip_path  # Arquivo ZIP gerado no pipeline
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      API_URL = var.api_url
    }
  }
}

# Criar API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "hello-api-${var.environment}"
  description = "API Gateway para a Lambda"
}

# Criar Recurso da API
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

# Criar Método da API
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Criar Integração com a Lambda
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.lambda_function.invoke_arn
}

# Criar Implantação da API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.environment
}

# Permitir API Gateway chamar a Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
}
