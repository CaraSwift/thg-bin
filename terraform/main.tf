provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./s3-bucket"
  bucket = var.s3_bucket_name  # Correct reference to the variable
}

module "iam" {
  source = "./iam-roles"
}

output "s3_bucket_name" {
  value = module.s3.bucket_name  # Assuming the s3 module has an output called `bucket_name`
}

output "iam_role_name" {
  value = module.iam.role_name  # Assuming the iam module has an output called `role_name`
}

