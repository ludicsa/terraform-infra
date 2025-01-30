variable "lambda_runtime" {}
variable "lambda_zip_file" {}

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