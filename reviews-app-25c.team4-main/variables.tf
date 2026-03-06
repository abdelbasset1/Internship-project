
variable "teammate_ids" {
  type        = list(string)
  description = "List of 12-digit AWS Account IDs for the team"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the Route 53 hosted zone"
}

# ── ASG: shared ──────────────────────────────────────────────────────────────

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances across all Auto Scaling Groups."
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances across all Auto Scaling Groups."
  default     = 5
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances at launch for all Auto Scaling Groups."
  default     = 1
}

variable "asg_cpu_target_value" {
  type        = number
  description = "Target average CPU utilization (%) for the target tracking scaling policy."
  default     = 60
}

# ── ASG: frontend ─────────────────────────────────────────────────────────────

variable "frontend_name_prefix" {
  type        = string
  description = "Name prefix for all frontend ASG resources."
}

variable "frontend_instance_type" {
  type        = string
  description = "EC2 instance type for the frontend ASG."
  default     = "t3.micro"
}

variable "frontend_ami_ssm_path" {
  type        = string
  description = "SSM Parameter Store path for the frontend AMI ID."
  default     = "/custom-amis/reviews-app/frontend-ami-id"
}

variable "frontend_app_port" {
  type        = number
  description = "Port the frontend application listens on."
  default     = 80
}

# ── ASG: backend ──────────────────────────────────────────────────────────────

variable "backend_name_prefix" {
  type        = string
  description = "Name prefix for all backend ASG resources."
}

variable "backend_instance_type" {
  type        = string
  description = "EC2 instance type for the backend ASG."
  default     = "t3.micro"
}

variable "backend_ami_ssm_path" {
  type        = string
  description = "SSM Parameter Store path for the backend AMI ID."
  default     = "/custom-amis/reviews-app/backend-ami-id"
}

variable "backend_app_port" {
  type        = number
  description = "Port the backend application listens on."
  default     = 5000
}

# ── RDS ───────────────────────────────────────────────────────────────────────

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

# ── Bastion ───────────────────────────────────────────────────────────────────

variable "project_name" {
  type = string
}

variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type for bastion (free tier: t2.micro)"
  default     = "t3.micro"
}

variable "bastion_allowed_ssh_cidrs" {
  type        = list(string)
  description = "Allowed SSH CIDRs, e.g. [\"1.2.3.4/32\"]"
}

variable "bastion_ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys to add to bastion authorized_keys"
}

# ALB + domains
variable "alb_name" {
  description = "Name prefix for ALB resources"
  type        = string
}

variable "frontend_subdomain" {
  type = string
}

variable "backend_subdomain" {
  type = string
}

variable "frontend_port" { 
  type = number
  description = "Port the frontend application listens on (for ALB target group)"
  default     = 80
}
variable "backend_port" { 
  type = number
  description = "Port the backend application listens on (for ALB target group)"
  default     = 5000 
}

variable "frontend_host" { 
  type = string 
  description = "Frontend domain for ALB listener rules (e.g. reviews.4everdevopsteam.click)"
}
variable "backend_host" { 
  type = string 
  description = "Backend domain for ALB listener rules (e.g. api.4everdevopsteam.click)"
}


variable "route53_zone_id" {
  description = "Hosted zone ID in Route53 for domain records"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}

# ── CloudWatch Monitoring ─────────────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region for CloudWatch metrics"
  type        = string
  default     = "us-east-1"
}

variable "alarm_emails" {
  description = "Email addresses to subscribe to CloudWatch alarm notifications"
  type        = list(string)
  default     = []
}

variable "sns_topic_name" {
  description = "Name of SNS topic for CloudWatch alerts"
  type        = string
  default     = "reviews-alerts-topic"
}

variable "dashboard_name" {
  description = "Name of CloudWatch dashboard"
  type        = string
  default     = "reviews-monitoring-dashboard"
}

variable "rds_cpu_threshold" {
  description = "RDS CPU utilization threshold (%) for alarm"
  type        = number
  default     = 75
}

variable "rds_cpu_evaluation_periods" {
  description = "Number of periods to evaluate for RDS CPU alarm (each period = 60 seconds)"
  type        = number
  default     = 10
}

variable "alb_error_threshold" {
  description = "ALB HTTP 5XX error count threshold for alarm"
  type        = number
  default     = 1
}

variable "alb_error_evaluation_periods" {
  description = "Number of periods to evaluate for ALB error alarm"
  type        = number
  default     = 1
}

variable "alarm_period" {
  description = "Period in seconds for CloudWatch alarm evaluation"
  type        = number
  default     = 60
}
