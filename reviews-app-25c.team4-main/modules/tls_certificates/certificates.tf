resource "aws_acm_certificate" "reviews" {
  domain_name       = var.pub_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = "4everdevopsteam.click"
  }
}

resource "aws_acm_certificate" "reviews_api" {
  domain_name       = var.private_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "reviews-api.4everdevopsteam.click"
  }
}

data "aws_route53_zone" "zone" {
  count        = var.hosted_zone_id == "" ? 1 : 0
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "reviews_validation" {
  for_each = {
    for dvo in aws_acm_certificate.reviews.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.hosted_zone_id != "" ? var.hosted_zone_id : data.aws_route53_zone.zone[0].zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "reviews" {
  certificate_arn         = aws_acm_certificate.reviews.arn
  validation_record_fqdns = [for r in aws_route53_record.reviews_validation : r.fqdn]
}

resource "aws_route53_record" "review_api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.reviews_api.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.hosted_zone_id != "" ? var.hosted_zone_id : data.aws_route53_zone.zone[0].zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "reviews_api" {
  certificate_arn         = aws_acm_certificate.reviews_api.arn
  validation_record_fqdns = [for r in aws_route53_record.review_api_validation : r.fqdn]
}