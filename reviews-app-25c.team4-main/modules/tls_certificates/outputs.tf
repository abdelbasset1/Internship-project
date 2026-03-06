output "zone_id" {
  value = var.hosted_zone_id != "" ? var.hosted_zone_id : data.aws_route53_zone.zone[0].id
}
output "reviews_cert_arn" {
  description = "ARN of the public reviews certificate"
  value       = aws_acm_certificate.reviews.arn
}

output "certificate_arn" {
  description = "(deprecated) legacy name for the certificate ARN — same value as reviews_cert_arn"
  value       = aws_acm_certificate.reviews.arn
}

output "reviews_api_cert_arn" {
  description = "ARN of the private reviews-api certificate"
  value       = aws_acm_certificate.reviews_api.arn
}

output "domain_name" {
  description = "The domain name for which the ACM certificate is issued"
  value       = aws_acm_certificate.reviews.domain_name
}