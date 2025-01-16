# Elastic IP
resource "aws_eip" "example_eip" {
  vpc = true
}

# Security Group
resource "aws_security_group" "example_sg" {
  name        = "example-sec-group"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Associate Elastic IP with the instance
resource "aws_eip_association" "example_eip_assoc" {
  instance_id   = aws_instance.example_ec2.id
  allocation_id = aws_eip.example_eip.id
}
