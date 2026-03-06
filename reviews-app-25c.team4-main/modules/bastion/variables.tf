variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "db_sg_id" {
  type        = string
  description = "Security group ID of the DB (RDS) to allow MySQL from bastion"
}

variable "instance_type" {
  type        = string
  description = "Bastion instance type"
  default     = "t2.micro"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to SSH to bastion"
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys to add to authorized_keys"
  default     = []
}

variable "iam_instance_profile_name" {
  type        = string
  description = "Name of the IAM instance profile to attach to the bastion instance."
  default     = null
}