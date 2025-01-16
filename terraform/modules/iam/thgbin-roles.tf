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

resource "aws_iam_policy" "thgbin_s3_policy" {
  name   = "thgbin-s3-access-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "arn:aws:s3:::thgbin-bucket",
      "arn:aws:s3:::thgbin-bucket/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.thgbin_ec2.name
  policy_arn = aws_iam_policy.thgbin_s3_policy.arn
}



