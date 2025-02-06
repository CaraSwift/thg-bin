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
  api_token = var.cloudflare_api_token
}

# Cloudflare DNS Record
resource "cloudflare_record" "app" {
  zone_id = var.cloudflare_zone_id
  name    = "app"
  content = aws_instance.thgbin_instance.public_ip  # Uses EC2's public IP
  type    = "A"
  ttl     = 300
  proxied = true  # Enable Cloudflare Proxy
}
