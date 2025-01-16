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

resource "aws_iam_policy" "thgbin_policy" {
  name        = "thgbin_s3_policy"
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


resource "aws_s3_bucket_policy" "thgbin_s3_policy" {
  bucket = aws_s3_bucket.thgbin_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::491085414522:role/thgbin_ec2" } # Correct Principal
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

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.thgbin_ec2.name
  policy_arn = aws_iam_policy.thgbin_policy.arn
}





