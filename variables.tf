variable "environment" {
  description = "Ambiente de deploy (dev/prod)"
  type        = string
}

variable "lambda_zip_path" {
  description = "Caminho do arquivo ZIP da Lambda"
  type        = string
}

variable "tech" {
  description = "Tecnologia utilizada na Lambda (Python, Node.js, etc.)"
  type        = string
}
