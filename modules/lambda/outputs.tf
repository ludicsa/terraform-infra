output "lambda_function_name" {
  description = "Nome da Lambda Function"
  value       = aws_lambda_function.lambda_function.function_name
}

output "api_gateway_url" {
  description = "URL do API Gateway"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}
