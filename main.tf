variable "lambda_runtime" {}
variable "lambda_zip_file" {}



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
  function_name = "my_lambda_function"
  runtime       = var.lambda_runtime
  handler       = "index.handler"
  filename      = var.lambda_zip_file
  role          = aws_iam_role.lambda_role.arn  
}


terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-87879564"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
