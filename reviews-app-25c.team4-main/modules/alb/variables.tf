variable "name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "alb_sg_id" { type = string }

variable "frontend_port" { type = number }
variable "backend_port" { type = number }

variable "frontend_host" { type = string }
variable "backend_host" { type = string }

variable "cert_frontend_arn" { type = string }
variable "cert_backend_arn" { type = string }

variable "tags" { type = map(string) }
