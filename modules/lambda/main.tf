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
}
