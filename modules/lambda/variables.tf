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

variable "runtime" {
  description = "Runtime da Lambda (ex: python3.9, nodejs18.x, etc.)"
  type        = string
}
