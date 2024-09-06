variable "aws_region" {
  description = "AWS region to deploy the resources"
	default = "eu-west-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
}

variable "ssh_key_path" {
  description = "The path to the SSH public key file"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block to allow SSH access"
}

variable "instance_type" {
  description = "Type of EC2 instance to run"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}
