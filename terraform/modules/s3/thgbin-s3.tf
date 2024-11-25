resource "aws_s3_bucket" "thgbin_bucket"
  bucket = "thgbin-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "thgbin Terraform State"
  }
}
