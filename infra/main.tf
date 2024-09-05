provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-ec2-key"
  public_key = file("~/.ssh/my-ec2-key.pub")
}

module "ec2_instances" {
  source = "./modules/ec2_instances"
  subnet_id = module.vpc.public_subnet_id
  security_group_id = module.security_groups.security_group_id
	key_name = aws_key_pair.deployer.key_name
}

output "ec2_instance_public_ip" {
  value = module.ec2_instances.public_instance_ip
}

