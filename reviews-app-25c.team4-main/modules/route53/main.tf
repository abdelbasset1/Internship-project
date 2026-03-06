# This looks up the zone you created manually to get its ID
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# Frontend record
resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = var.frontend_host
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Backend record
resource "aws_route53_record" "backend" {
  zone_id = var.zone_id
  name    = var.backend_host
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}