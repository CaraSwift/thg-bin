resource "aws_s3_bucket" "thgbin_bucket" {
  bucket = "thgbin-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "S3 Bucket THGBIN"
  }
}

resource "aws_s3_bucket_public_access_block" "thgbin_public_access" {
  bucket                  = aws_s3_bucket.thgbin_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



