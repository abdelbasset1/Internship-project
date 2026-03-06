db_password = "ChooseAStrongPassword123!"


# ── Bastion Server Configuration ──────────────────────────────────────────────
project_name          = "reviews-app"
bastion_instance_type = "t3.micro"
# Requirement: SSH access from authorized users only.
bastion_allowed_ssh_cidrs = ["0.0.0.0/0"]
bastion_ssh_public_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAwU/c6kZZJNtqzZMoWdoGHTiVCYbd68hmOGIaWZK6ydiirU0r8KMaJy6UQZs5woX6dlSwn9EnwR9M+M7Aql/fAb3mXCJ/aaIrCCncNXU3zS+7bPNpoqe046bt9de7YZdDZu8eLydJFWFQ83LYw80QIklJfTDa85E6XfBJUcxWoWTrUS2wl9cAv/hy8Zhf+4++G5YPqNo9VFHMcXO0dyqhx9NvgEetZ812EbjHXVwuOmrep3+E02mBYbHSfheQDwPn98SEJc5UyHNUYMgJgvPR4k2F3LuXiVbZI94QEcZuhDtS4FAvJ8ZikzvsEQGOWswRhYH7pBQ+gtDydTGaGU+6xtcxbEJsmYv43rmD9nZOaSdfZQQXF310JiCdfpCMmCpqlq03TG29iSLC5qyK0bdd5Bqa3azTK7etXtCooevZ33ljGw5L+YuBWoEmIHQQAUdfx/wTm58gWlCa0t+PrJX/2l8s6cNYn1IRDff3PKWDoP26Ws/NlKLQhO5bS6+8ib0= ecaterinapopinina@MacBookPro",
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFeyBOgi... val@Valerius-MacBook-Air.local",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzlDXm... iurieplesu@Iuries-MacBook-Air.local",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpnQLw... bb@BBs-MacBook-Pro.local",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsOkgh... irynasfiles@Irynas-MacBook-Air.local",
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXVeRve... sashasamay@Alexanders-MacBook-Air.local",
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv1/grB+ISp1o9fgY3aHETVwfbUj30STRAwcBsNE17b housn@DESKTOP-DM5DL6S",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC43xreeiQBEm0riQVk2D9e86Xvx2TjYswq1wwhbxjeKl4/YUnMvBw5J4/qXIIOHeLTamq4Kw/z3nWz+q0M4s570U2kV7H4DDH2OM4hFSEN7ESRlNndl0KPsbHMdlvY9/lQR1P47nYXOVWUyYqnQrsrmfTpM8yIzOIAccV57v7b11jppEkPF6fJPqLpH+0MMcFiqfP0+hfBhI1fAe7CirwboT+ndDrPueCGNb1OZxEKFI9LZ9GA2oxPSRV7l85cY52gZjwLo8WBFEpGmkJ2X3wC1lP89Cpms9U3EG9uL93AVwH3B5NZBgH3qZCN9lM/thkG/ybaPVDjt6Ypw3hBP4+jaFILBUPV8Bo1BHTPdM1mgSMeNXCMlv7cGDVYh6J1aEJ0u2eviCQdDMdK3R+210ct1GVOC3rxuURGqlrYfiPEPq6ACOoR8esP7Mglp7M6aMxJR8g7BDGq9UVfMgCCPO4RzxIV8KyhfSYLWVr6fX517pqkKfg0J8G6OaTimHiAeKjcrPp08JqhA7AUTkyl0ErCc7yN2QGmDWkx7CRp5H0fM0St2HozdeMh5dFjLKj77iartFzGWC3KgufZbQduCn8wlb3RZsrRFaPxHC7UKuYf1R4hqLI55puV5NUI5FGVJZOftZ0G+Eh94+8DHMB1Rl3QgNQKpm+qmBWAHRgAVR0CNQ== natalia@Natalias-MacBook-Air.local"
]

# ── AWS Region ────────────────────────────────────────────────────────────────
aws_region = "us-east-1"

teammate_ids = [
  "878752032485",
  "513772208729",
  "715413100915",
  "570232566678",
  "477780047886",
  "700580650379",
  "340825716628",
  "472499667634"
]

# ── ASG: shared ──────────────────────────────────────────────────────────────
asg_min_size         = 1
asg_max_size         = 5
asg_desired_capacity = 1
asg_cpu_target_value = 60

# ── ASG: frontend ─────────────────────────────────────────────────────────────
frontend_name_prefix   = "reviews-app-frontend"
frontend_instance_type = "t3.micro"
frontend_ami_ssm_path  = "/custom-amis/reviews-app/frontend-ami-id"
frontend_app_port      = 80

# ── ASG: backend ──────────────────────────────────────────────────────────────
backend_name_prefix   = "reviews-app-backend"
backend_instance_type = "t3.micro"
backend_ami_ssm_path  = "/custom-amis/reviews-app/backend-ami-id"
backend_app_port      = 5000

alb_name           = "reviews-app"
domain_name        = "4everdevopsteam.click"
frontend_subdomain = "reviews"
backend_subdomain  = "api"
route53_zone_id    = "Z0470081250Z4PSWAAIEW"


tags = {
  Project = "reviews-app"
  Env     = "dev"
}



# SNS and Dashboard naming
sns_topic_name     = "reviews-alerts-topic"
dashboard_name     = "reviews-monitoring-dashboard"

# Email addresses for SNS notifications 
alarm_emails = [
  "iryna.roz@edu.312school.com",
  "natalia.tar@edu.312school.com",
  "alexander.sam@edu.312school.com",
  "ecaterina.pop@edu.312school.com",
  "inga.jum@edu.312school.com",
  "abdelbasset.hou@edu.312school.com",
  "iurie.ple@edu.312school.com"
]

# RDS CPU Alarm settings
rds_cpu_threshold = 75                    # CPU percentage threshold
rds_cpu_evaluation_periods = 10           # 10 periods of 60 seconds = 10 minutes

# ALB HTTP Error Alarm settings
alb_error_threshold = 1                   # Number of 5xx errors
alb_error_evaluation_periods = 1  
backend_port = 5000 
frontend_port = 80

# Domains for routing
frontend_host       = "reviews.4everdevopsteam.click"
backend_host        = "api.4everdevopsteam.click"



# Alarm period (used for both alarms)
alarm_period = 60                         # 60 seconds per period