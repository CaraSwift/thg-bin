resource "aws_s3_bucket" "thgbin_bucket" {
  bucket = "thgbin-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "S3 Bucket THGBIN"
  }
}

resource "aws_s3_bucket_public_access_block" "thgbin_public_access" {
  bucket                  = aws_s3_bucket.thgbin_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "thgbin_policy" {
  bucket = aws_s3_bucket.thgbin_bucket.id

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


