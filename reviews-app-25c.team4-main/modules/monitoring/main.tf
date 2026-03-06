terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_sns_topic" "alerts" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "emails" {
  for_each = { for idx, addr in var.alarm_emails : idx => addr }
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_dashboard" "monitoring" {
  dashboard_name = var.dashboard_name
  dashboard_body = templatefile("${path.module}/dashboard.json.tpl", {
    db_instance_identifier = var.db_instance_identifier
    alb_name = var.alb_name
    asg_name = var.asg_name
    region = var.region
  })
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "rds-cpu-high-${var.db_instance_identifier}"
  alarm_description   = "Alarm when RDS CPU exceeds threshold"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }
  statistic           = "Average"
  period              = var.alarm_period
  evaluation_periods  = var.rds_cpu_evaluation_periods
  threshold           = var.rds_cpu_threshold
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "alb-5xx-errors-${var.alb_name}"
  alarm_description   = "Alarm when ALB target 5xx errors occur"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  dimensions = {
    LoadBalancer = var.alb_name
  }
  statistic           = "Sum"
  period              = var.alarm_period
  evaluation_periods  = var.alb_error_evaluation_periods
  threshold           = var.alb_error_threshold
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
}
