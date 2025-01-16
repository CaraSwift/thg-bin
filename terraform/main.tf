provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./.terraform"
}

module "iam" {
  source = "./.terraform"
}

