resource "aws_instance" "thgbin_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.aws_key_pair
  security_groups = [
    aws_security_group.thgbin_sg.name
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "S3-Access-EC2"
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.thgbin_ec2.name
}
