terraform {
  backend "s3" {
    bucket = "terraform-tfstate-87879564"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}
