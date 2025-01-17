variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "eu-west-2"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "thgbin_bucket"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "aws_key_pair" {
  description = "The key pair name for EC2 instance"
  default     = "thgbin"

}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-091f18e98bc129c4e"
}
