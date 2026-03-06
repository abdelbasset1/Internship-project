variable "pub_domain" {
  type    = string
  default = "reviews.4everdevopsteam.click"
}

variable "private_domain" {
  type    = string
  default = "reviews-api.4everdevopsteam.click"
}

variable "maintenance_domain" {
  type    = string
  default = "maintenance.reviews.4everdevopsteam.click"
}

variable "domain_name" {
  description = "domain name of website"
  type        = string
  default     = "4everdevopsteam.click"
}

variable "hosted_zone_id" {
  description = "Optional Route53 hosted zone ID to use instead of data lookup"
  type        = string
  default     = ""
}