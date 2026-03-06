data "aws_iam_instance_profile" "ssm_secret_manager" {
  name = "SSMSecretManager"
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

module "iam_cross_account" {
  source       = "./modules/iam-cross-account"
  teammate_ids = var.teammate_ids
}

module "route53" {
  source      = "./modules/route53"
  domain_name = var.domain_name  # Your required variable
  
  # Add these new lines from your teammate's version:
  zone_id      = data.aws_route53_zone.main.zone_id
  frontend_host = "${var.frontend_subdomain}.${var.domain_name}"
  backend_host  = "${var.backend_subdomain}.${var.domain_name}"
  alb_dns_name  = module.alb.dns_name
  alb_zone_id   = module.alb.zone_id
}

# VPC #
module "vpc" {
  source      = "./modules/vpc"
  name_prefix = "reviews-app"

  vpc_cidr_block       = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_cidrs                        = ["10.1.1.0/24", "10.1.2.0/24"]
  map_public_ip_on_launch_for_public_subnet  = true
  private_subnet_cidrs                       = ["10.1.101.0/24", "10.1.102.0/24"]
  map_public_ip_on_launch_for_private_subnet = false
}

#==============================================
#               Auto Scaling Module (Iryna)
#==============================================

# Frontend ASG #
module "frontend_asg" {
  source = "./modules/autoscale"

  name_prefix            = var.frontend_name_prefix
  ami_ssm_parameter_name = var.frontend_ami_ssm_path
  instance_type          = var.frontend_instance_type
  app_port               = var.frontend_app_port

  security_group_ids = [module.vpc.frontend_app_sg_id]
  subnet_ids         = module.vpc.public_subnets
  target_group_arns  = [module.alb.frontend_tg_arn]

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  cpu_target_value = var.asg_cpu_target_value

  key_name = "mini-project"
}

# Backend ASG #
module "backend_asg" {
  source = "./modules/autoscale"

  name_prefix            = var.backend_name_prefix
  ami_ssm_parameter_name = var.backend_ami_ssm_path
  instance_type          = var.backend_instance_type
  app_port               = var.backend_app_port

  security_group_ids = [module.vpc.backend_app_sg_id]
  subnet_ids         = module.vpc.private_subnets
  target_group_arns  = [module.alb.backend_tg_arn]

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  cpu_target_value = var.asg_cpu_target_value

  iam_instance_profile_name = data.aws_iam_instance_profile.ssm_secret_manager.name
  key_name                  = "mini-project"
}

module "rds_mysql_reviews" {
  source = "./modules/rds_mysql_reviews"

  db_identifier = "reviews-mysql-db"
  db_name       = "reviewsdb"
  db_username   = "admin"
  db_password   = var.db_password

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_subnet_ids         = module.vpc.private_subnets
  db_security_group_ids = [module.vpc.db_sg_id]


  secret_name = "reviews-db-credentials-v5"
}


module "alb" {
  source = "./modules/alb"

  name           = var.alb_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.vpc.alb_sg_id

  frontend_port = var.frontend_app_port
  backend_port  = var.backend_app_port

  frontend_host = "${var.frontend_subdomain}.${var.domain_name}"
  backend_host  = "${var.backend_subdomain}.${var.domain_name}"

  # TLS
  cert_frontend_arn = module.acm.frontend_cert_arn
  cert_backend_arn  = module.acm.backend_cert_arn

  tags = var.tags
}

module "acm" {
  source = "./modules/acm"

  zone_id = data.aws_route53_zone.main.zone_id

  frontend_host = "${var.frontend_subdomain}.${var.domain_name}"
  backend_host  = "${var.backend_subdomain}.${var.domain_name}"
}


#==============================================
#         CloudWatch Monitoring Module
#==============================================

module "monitoring" {
  source = "./modules/monitoring"

  region = var.aws_region
  db_instance_identifier = module.rds_mysql_reviews.db_instance_id
  alb_name               = module.alb.alb_arn_suffix
  asg_name               = module.frontend_asg.asg_name

  alarm_emails           = var.alarm_emails
  sns_topic_name         = var.sns_topic_name
  dashboard_name         = var.dashboard_name

  rds_cpu_threshold             = var.rds_cpu_threshold
  rds_cpu_evaluation_periods    = var.rds_cpu_evaluation_periods
  alb_error_threshold           = var.alb_error_threshold
  alb_error_evaluation_periods  = var.alb_error_evaluation_periods
  alarm_period                  = var.alarm_period
}

#==============================================
#         Security Group Rules (Fixes)
#==============================================

resource "aws_security_group_rule" "alb_to_backend" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = module.vpc.alb_sg_id
  security_group_id        = module.vpc.backend_app_sg_id
  description              = "Allow ALB to communicate with Backend on port 5000"
}

resource "aws_security_group_rule" "backend_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.vpc.backend_app_sg_id
  security_group_id        = module.vpc.db_sg_id
  description              = "Allow Backend to communicate with RDS"
}
