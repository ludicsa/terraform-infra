module "lambda" {
  source          = "../modules/lambda"
  environment     = "prod"
  api_url         = "https://api-prod.meusistema.com"
  lambda_zip_path = "lambda.zip"
}

