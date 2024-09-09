resource "aws_instance" "bird" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]
	key_name        = var.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
    #cloud-config
    package_update: true
    packages:
      - ansible

    runcmd:
      - echo "Cloud-init script has run successfully!" > /tmp/trial.txt
      - ansible-playbook /tmp/run_playbook.yml
  EOF

  provisioner "file" {
    source      = "/Users/box/src/own/lifi-assignment/devops-challenge/infra/ansible/deploy_k8s.yaml"
    destination = "/tmp/run_playbook.yml"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/Users/box/.ssh/my-ec2-key")
  } 
	tags = {
		Name = "bird"
	}
}
output "public_instance_ip" {
  value = aws_instance.bird.public_ip
}

