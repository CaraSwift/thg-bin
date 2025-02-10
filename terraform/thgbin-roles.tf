# IAM Role for EC2
resource "aws_iam_role" "thgbin_ec2" {
  name               = "thgbin-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Policy to Allow EC2 Access to S3
resource "aws_iam_policy" "thgbin_policy" {
  name        = "thgbin_policy"
  description = "Policy to allow EC2 access to S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::thgbin-bucket",
          "arn:aws:s3:::thgbin-bucket/*"
        ]
      }
    ]
  })
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.thgbin_ec2.name
  policy_arn = aws_iam_policy.thgbin_policy.arn
}

# Attach AWS Managed CloudWatch Logs Policy to IAM Role
resource "aws_iam_role_policy_attachment" "thgbin_cloudwatch_logs" {
  role       = aws_iam_role.thgbin_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# S3 Bucket Policy to Allow Access to the EC2 Role
resource "aws_s3_bucket_policy" "thgbin_s3_policy" {
  bucket = aws_s3_bucket.thgbin_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "${aws_iam_role.thgbin_ec2.arn}" }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::thgbin-bucket",
          "arn:aws:s3:::thgbin-bucket/*"
        ]
      }
    ]
  })
}
