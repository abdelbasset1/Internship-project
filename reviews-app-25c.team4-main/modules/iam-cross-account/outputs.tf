output "role_arn" {
  value       = aws_iam_role.shared_admin_role.arn
  description = "The ARN for teammates to use when Switching Roles"
}

output "switch_role_link" {
  value       = "https://signin.aws.amazon.com/switchrole?account=${data.aws_caller_identity.current.account_id}&roleName=${aws_iam_role.shared_admin_role.name}"
  description = "Click this link to log into the shared environment"
}