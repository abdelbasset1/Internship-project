# Monitoring Module

This Terraform module creates CloudWatch monitoring infrastructure for the Reviews app, including:

- **SNS Topic**: Alert notifications via email
- **CloudWatch Dashboard**: 10+ widgets tracking RDS, ALB, and ASG metrics
- **RDS CPU Alarm**: Triggers when CPU exceeds 75% for 10 consecutive minutes
- **ALB 5XX Error Alarm**: Triggers when HTTP 5XX errors occur

## Usage

The module is automatically called in the root `main.tf` and pulls its configuration from `terraform.tfvars`.

### Configuration

Update your root `terraform.tfvars` with:

```hcl
# Email addresses for alarm notifications
alarm_emails = [
  "devops-team@company.com",
  "on-call@company.com"
]

# RDS CPU threshold (%)
rds_cpu_threshold = 75

# RDS CPU evaluation periods (each period = 60 seconds, so 10 = 10 minutes)
rds_cpu_evaluation_periods = 10

# ALB error threshold (number of 5xx errors to trigger alarm)
alb_error_threshold = 1

# Alarm evaluation period for ALB errors
alb_error_evaluation_periods = 1

# Common period for all alarms (in seconds)
alarm_period = 60
```

## Outputs

- `sns_topic_arn`: ARN of the SNS topic for alerts
- `dashboard_name`: Name of the CloudWatch dashboard

## Notes

- SNS email subscriptions require confirmation via email links sent to each subscriber
- Dashboard metrics take time to populate after resources are created
- Adjust thresholds in `terraform.tfvars` based on your application's typical behavior
