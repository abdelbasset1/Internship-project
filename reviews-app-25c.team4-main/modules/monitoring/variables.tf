variable "region" {
  type    = string
  default = "us-east-1"
}

variable "db_instance_identifier" {
  type        = string
  description = "RDS DB instance identifier to monitor (set in tfvars)"
  default     = ""
}

variable "alb_name" {
  type        = string
  description = "ALB LoadBalancer dimension name (e.g. app/my-alb/123456)"
  default     = ""
}

variable "asg_name" {
  type        = string
  description = "Auto Scaling Group name to include on dashboard"
  default     = ""
}

variable "alarm_emails" {
  type        = list(string)
  description = "List of email addresses to subscribe to the SNS topic"
  default     = []
}

variable "sns_topic_name" {
  type    = string
  default = "reviews-alerts-topic"
}

variable "dashboard_name" {
  type    = string
  default = "reviews-monitoring-dashboard"
}

variable "rds_cpu_threshold" {
  type    = number
  default = 75
}

variable "rds_cpu_evaluation_periods" {
  type    = number
  default = 10
}

variable "alb_error_threshold" {
  type    = number
  default = 1
}

variable "alb_error_evaluation_periods" {
  type    = number
  default = 1
}

variable "alarm_period" {
  type    = number
  default = 60
}
