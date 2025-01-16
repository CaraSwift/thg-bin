output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.thgbin_bucket.bucket # Direct reference to the S3 bucket resource
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.thgbin_bucket.arn # Direct reference to the S3 bucket ARN
}

output "iam_role_name" {
  description = "The name of the IAM role for EC2 instance"
  value       = aws_iam_role.thgbin_ec2.name # Direct reference to the IAM role resource
}

output "iam_role_arn" {
  description = "The ARN of the IAM role for EC2 instance"
  value       = aws_iam_role.thgbin_ec2.arn # Direct reference to the IAM role ARN
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_eip.static_ip.public_ip
}


