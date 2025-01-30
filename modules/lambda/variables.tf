variable "environment" {
  description = "Ambiente (dev/prod)"
  type        = string
}

variable "api_url" {
  description = "URL da API Gateway"
  type        = string
}

variable "lambda_zip_path" {
  description = "Caminho do arquivo ZIP da Lambda"
  type        = string
}
