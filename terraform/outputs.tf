output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_name  # Assuming the module outputs `bucket_name`
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.thgbin_bucket.arn
}

output "iam_role_name" {
  description = "The name of the IAM role for EC2 instance"
  value       = module.iam.role_name  # Assuming the module outputs `role_name`
}

output "iam_role_arn" {
  description = "The ARN of the IAM role for EC2 instance"
  value       = aws_iam_role.thgbin_ec2.arn
}


