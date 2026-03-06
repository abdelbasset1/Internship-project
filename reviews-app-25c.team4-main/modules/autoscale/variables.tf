variable "name_prefix" {
  type        = string
  description = "Prefix used for naming all resources in this module (e.g. reviews-app-frontend)."
}

variable "ami_ssm_parameter_name" {
  type        = string
  description = "SSM Parameter Store path where the AMI ID is stored (e.g. custom-amis/reviews-app/frontend-ami-id)."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the launch template."
  default     = "t3.medium"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach to instances. Pass the relevant SG ID from the VPC module output."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in which the ASG will launch instances. Use public subnets for frontend, private for backend."
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in the Auto Scaling Group."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling Group."
  default     = 5
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in the Auto Scaling Group."
  default     = 1
}

variable "cpu_target_value" {
  type        = number
  description = "Target average CPU utilization percentage for the target tracking scaling policy."
  default     = 60
}

variable "app_port" {
  type        = number
  description = "Port the application listens on. Used to tag and identify the instance role."
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name for SSH access. Leave null if SSH access is not needed."
  default     = null
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of ALB target group ARNs to attach to this ASG."
  default     = []
}

variable "iam_instance_profile_name" {
  type        = string
  description = "Name of the IAM instance profile to attach to launched instances."
  default     = null
}
