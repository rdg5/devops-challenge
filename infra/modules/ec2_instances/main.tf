variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be created"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to attach to the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The SSH key name to use for accessing the EC2 instance"
  type        = string
}

resource "aws_instance" "bird" {
  ami           = "ami-09634b5569ee59efb"
  instance_type = "t3.small"

  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]
	key_name        = var.key_name
  associate_public_ip_address = true
	user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io

              sudo systemctl start docker
              sudo systemctl enable docker

              sudo docker network create bird_network

              sudo docker run -d --name birdapi --network bird_network -p 4201:4201 rdg5/birdapi:latest

              sudo docker run -d --name birdimageapi --network bird_network -p 4200:4200 rdg5/birdimageapi:latest
              EOF

  tags = {
    Name = "bird-instance"
  }
}

output "public_instance_ip" {
  value = aws_instance.bird.public_ip
}

