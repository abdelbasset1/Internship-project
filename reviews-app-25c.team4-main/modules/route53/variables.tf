variable "zone_id" { type = string }
variable "frontend_host" { type = string }
variable "backend_host" { type = string }
variable "alb_dns_name" { type = string }
variable "alb_zone_id" { type = string }
variable "domain_name" {
  type        = string
  description = "The domain name passed from the root module for Route 53 lookup"
}