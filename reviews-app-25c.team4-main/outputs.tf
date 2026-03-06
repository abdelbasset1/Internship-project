output "frontend_url" {
  description = "URL for the Frontend Application"
  value       = "https://${var.frontend_subdomain}.${var.domain_name}"
}

output "backend_url" {
  description = "URL for the Backend API Root"
  value       = "https://${var.backend_subdomain}.${var.domain_name}"
}

output "backend_health_url" {
  description = "URL for the Backend Health Check"
  value       = "https://${var.backend_subdomain}.${var.domain_name}/health"
}