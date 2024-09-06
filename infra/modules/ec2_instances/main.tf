resource "aws_instance" "bird" {
  ami           = var.ami_id
  instance_type = var.instance_type

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

