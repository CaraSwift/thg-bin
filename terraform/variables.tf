variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "eu-west-2"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for IAM role"
}

