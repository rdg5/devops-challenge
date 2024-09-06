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

							curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
              curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
							helm repo add stable https://charts.helm.sh/stable
							helm repo update
              EOF

  tags = {
    Name = "bird-instance"
  }
}

output "public_instance_ip" {
  value = aws_instance.bird.public_ip
}

