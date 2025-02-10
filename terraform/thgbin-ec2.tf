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
              sudo apt update -y
              sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              sudo apt update -y
              sudo apt install docker-ce docker-ce-cli containerd.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo yum install amazon-cloudwatch-agent -y
              sudo systemctl enable amazon-cloudwatch-agent
              sudo systemctl start amazon-cloudwatch-agent
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              sudo usermod -aG docker ubuntu
              newgrp docker
              sudo mkdir -p /opt/privatebin
              sudo chown ubuntu:ubuntu /opt/privatebin
              sudo chmod 755 /opt/privatebin
              echo "EC2 setup complete"
              EOF
}

resource "aws_iam_instance_profile" "thgbin_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.thgbin_ec2.name
}