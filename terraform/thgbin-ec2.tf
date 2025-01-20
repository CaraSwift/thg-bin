resource "aws_instance" "thgbin_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.aws_key_pair
  security_groups = [
    aws_security_group.thgbin_sg.name
  ]
  iam_instance_profile = aws_iam_instance_profile.thgbin_instance_profile.name
  tags = {
    Name = "S3-Access-EC2"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e  # Exit on any error
              # Update and install dependencies
              sudo apt update -y
              sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

              # Add Docker GPG key and repository
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

              # Update and install Docker
              sudo apt update -y
              sudo apt install -y docker-ce docker-ce-cli containerd.io

              # Start and enable Docker
              sudo systemctl start docker
              sudo systemctl enable docker

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose

              # Create necessary directories
              sudo mkdir -p /opt/privatebin
              EOF
}

resource "aws_iam_instance_profile" "thgbin_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.thgbin_ec2.name
}
