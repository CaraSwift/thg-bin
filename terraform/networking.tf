# Elastic IP
resource "aws_eip" "thgbin_ip" {
  instance = aws_instance.thgbin_instance.id

  tags = {
    Name = "thgbin_eip"
  }
}


# Security Group
resource "aws_security_group" "thgbin_sg" {
  name        = "thgbin-sec-group"
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

  ingress {
    description = "HTTP access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["8.29.109.68/32"]
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
resource "aws_eip_association" "thgbin_ip_ec" {
  instance_id   = aws_instance.thgbin_instance.id
  allocation_id = aws_eip.thgbin_ip.id
}
