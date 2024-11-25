resource "aws_iam_role" "ec2_privatebin_role" {
  name               = "ec2_privatebin_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "ec2_privatebin_s3_policy"
  description = "Policy to allow S3 access for PrivateBin EC2"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::your-privatebin-bucket/*"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_cloudwatch_policy" {
  name        = "ec2_privatebin_cloudwatch_policy"
  description = "Policy to allow CloudWatch logging from PrivateBin EC2"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_privatebin_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.ec2_privatebin_role.name
  policy_arn = aws_iam_policy.ec2_cloudwatch_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_privatebin_instance_profile"
  role = aws_iam_role.ec2_privatebin_role.name
}

# Terraform Execution Role
resource "aws_iam_role" "terraform_execution_role" {
  name               = "terraform_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action    = "sts:AssumeRole"
      },
      {
        Effect    = "Allow",
        Principal = { AWS = "arn:aws:iam::YOUR_ACCOUNT_ID:root" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_full_access_policy" {
  name        = "terraform_full_access_policy"
  description = "Policy to allow Terraform to manage AWS resources"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:*",
          "s3:*",
          "iam:*",
          "logs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_terraform_policy" {
  role       = aws_iam_role.terraform_execution_role.name
  policy_arn = aws_iam_policy.terraform_full_access_policy.arn
}
