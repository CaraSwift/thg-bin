terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = "terraform/terraform.tfstate"
    region         = var.aws_region
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

