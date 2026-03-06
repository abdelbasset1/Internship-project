variable "name_prefix" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "map_public_ip_on_launch_for_public_subnet" {
  type = bool
}

variable "map_public_ip_on_launch_for_private_subnet" {
  type = bool
}

variable "alb_http_port" {
  type    = number
  default = 80
}

variable "alb_https_port" {
  type    = number
  default = 443
}

variable "enable_https" {
  type    = bool
  default = true
}

variable "frontend_port" {
  type        = number
  description = "TCP port on which the frontend application listens. This port is opened to traffic originating from the Application Load Balancer (ALB)."
  default     = 80
}

variable "backend_app_port" {
  type        = number
  description = "TCP port on which the backend application listens. This port is accessible only from the ALB security group."
  default     = 5000
}

variable "db_port" {
  type        = number
  description = "TCP port used by the database engine (e.g., MySQL). Access is restricted to the backend application security group."
  default     = 3306
}
