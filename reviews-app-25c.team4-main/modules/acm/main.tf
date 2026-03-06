# ---------------------------
# Frontend certificate
# ---------------------------
resource "aws_acm_certificate" "frontend" {
  domain_name       = var.frontend_host
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "frontend_validation" {
  for_each = {
    for dvo in aws_acm_certificate.frontend.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "frontend" {
  certificate_arn         = aws_acm_certificate.frontend.arn
  validation_record_fqdns = [for r in aws_route53_record.frontend_validation : r.fqdn]
}

# ---------------------------
# Backend certificate
# ---------------------------
resource "aws_acm_certificate" "backend" {
  domain_name       = var.backend_host
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "backend_validation" {
  for_each = {
    for dvo in aws_acm_certificate.backend.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "backend" {
  certificate_arn         = aws_acm_certificate.backend.arn
  validation_record_fqdns = [for r in aws_route53_record.backend_validation : r.fqdn]
}