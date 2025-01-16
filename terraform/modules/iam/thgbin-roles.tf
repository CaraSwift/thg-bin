resource "aws_iam_role" "ec2_privatebin_role" {
  name = "privatebin-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_privatebin" {
  name   = "privatebin-s3-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::your-privatebin-bucket",
          "arn:aws:s3:::your-privatebin-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_privatebin.name
  policy_arn = aws_iam_policy.s3_privatebin.arn
}

resource "aws_instance" "privatebin" {
  ami           = "ami-12345678" # Replace with your desired AMI
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_privatebin.name

  tags = {
    Name = "PrivateBin"
  }
}

resource "aws_iam_instance_profile" "ec2_privatebin" {
  name = "privatebin-instance-profile"
  role = aws_iam_role.ec2_privatebin.name
}

