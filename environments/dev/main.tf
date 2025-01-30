module "lambda" {
  source          = "../modules/lambda"
  environment     = "dev"
  api_url         = "https://api-dev.meusistema.com"
  lambda_zip_path = "lambda.zip"
}

