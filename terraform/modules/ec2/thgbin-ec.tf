resource "aws_instance" "example" {
  ami           = "ami-12345678" # Replace with the AMI ID for your region
  instance_type = "t2.micro"     # Adjust instance type as needed

  # Key pair for SSH access
  key_name = "your-key-pair-name" # Replace with your key pair name

  # Security group to allow access
  vpc_security_group_ids = [aws_security_group.example.id]

  # Subnet for the instance
  subnet_id = "subnet-12345678" # Replace with your subnet ID

  # Tags for organization
  tags = {
    Name = "Example EC2 Instance"
  }
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow inbound traffic for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.5/32"] # Replace with your home IP for SSH
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Example Security Group"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
