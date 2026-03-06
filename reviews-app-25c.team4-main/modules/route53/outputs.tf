output "hosted_zone_id" {
  value       = data.aws_route53_zone.selected.zone_id
  description = "The ID of the Hosted Zone for the team to use"
}

output "nameservers" {
  value       = data.aws_route53_zone.selected.name_servers
  description = "The nameservers currently pointing to AWS"
}