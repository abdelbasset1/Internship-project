variable "db_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_security_group_ids" {
  type = list(string)
  description = "List of security group IDs for the RDS instance"
}

variable "secret_name" {
  type = string
}
