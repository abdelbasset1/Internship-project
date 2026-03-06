output "frontend_cert_arn" {
  value = aws_acm_certificate_validation.frontend.certificate_arn
}

output "backend_cert_arn" {
  value = aws_acm_certificate_validation.backend.certificate_arn
}