terraform {
  backend "s3" {
    bucket         = "state-bucket.tf"
    key            = "terraform/terraform.tfstate"
    region         = "eu-west-2"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5" # Ensure version compatibility
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# EC2 and other modules

data "aws_vpc" "devops-vpc" {
  id = "vpc-0d6f0907899d7ce33"
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

# Cloudflare Provider Block
provider "cloudflare" {
  api_token = var.CF_API_TOKEN
}

# Cloudflare DNS Record
resource "cloudflare_dns_record" "app" {
  zone_id = var.CF_ZONE
  name    = "app"
  content = aws_instance.thgbin_instance.public_ip  # Uses EC2's public IP
  type    = "A"
  ttl     = 1
  proxied = true  # Enable Cloudflare Proxy
}
