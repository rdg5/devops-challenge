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

variable "instance_type" {
  description = "Type of EC2 instance to run"
  default     = "t3.medium"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-09634b5569ee59efb"
}

variable "github_repo" {
  description = "Github repo to clone"
	type        = string
	default     = "https://github.com/rdg5/devops-challenge.git"
}
