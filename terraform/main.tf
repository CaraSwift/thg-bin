terraform {
  backend "s3" {
    bucket         = "thgbin-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "eu-west-2"
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./.terraform"
}

module "iam" {
  source = "./.terraform"
}

module "ec2" {
  source = "./.terraform"
  
}

