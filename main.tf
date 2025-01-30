module "lambda" {
  source = "./modules/lambda"

  environment     = var.environment
  lambda_zip_path = var.lambda_zip_path
  runtime         = var.runtime
}
