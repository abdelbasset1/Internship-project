variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "frontend_host" {
  description = "Frontend FQDN"
  type        = string
}

variable "backend_host" {
  description = "Backend FQDN"
  type        = string
}