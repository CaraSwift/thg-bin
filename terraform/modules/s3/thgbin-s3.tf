resource "aws_s3_bucket" "thgbin_bucket" {
  bucket = "thgbin-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "S3 Bucket THG"
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::thgbin-bucket",
        "arn:aws:s3:::thgbin-bucket/*"
      ]
    }
  ]
}
POLICY
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

