variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block to allow SSH access"
  default     = "0.0.0.0/0"
}
