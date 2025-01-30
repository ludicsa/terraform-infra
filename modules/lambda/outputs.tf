output "lambda_function_name" {
  description = "Nome da Lambda Function"
  value       = aws_lambda_function.lambda_function.function_name
}
