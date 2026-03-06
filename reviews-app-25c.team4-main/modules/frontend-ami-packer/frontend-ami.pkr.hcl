packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name_prefix" {
  type    = string
  default = "reviews-app-frontend-nginx"
}

# SSM parameter where the latest AMI id will be stored
variable "ssm_param_name" {
  type    = string
  default = "/custom-amis/reviews-app/frontend-ami-id"
}

source "amazon-ebs" "frontend" {
  region        = var.region
  instance_type = "t3.micro"
  ssh_username  = "ec2-user"

  # Latest Amazon Linux 2023 x86_64
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  ami_name        = "${var.name_prefix}-{{timestamp}}"
  ami_description = "Frontend AMI with nginx serving static site (built with Packer)"
}

build {
  name    = "reviews-app-frontend-ami"
  sources = ["source.amazon-ebs.frontend"]

  # Copy repo frontend files into the instance
  provisioner "file" {
    source      = "../../frontend"
    destination = "/tmp/frontend"
  }

  # Install nginx + move files into nginx html dir + enable on boot + validate
  provisioner "shell" {
    script = "scripts/setup_frontend_nginx.sh"
  }

  # Create a manifest json file so we can reliably capture AMI id
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }

  # Store AMI id into SSM Parameter Store (overwrite)
  post-processor "shell-local" {
    inline = [
      "jq -r '.builds[-1].artifact_id' manifest.json | awk -F: '{print $2}' > ami_id.txt",
      "AMI_ID=$(cat ami_id.txt)",
      "echo \"Built AMI: $AMI_ID\"",
      "aws ssm put-parameter --name \"${var.ssm_param_name}\" --type String --value \"$AMI_ID\" --overwrite"
    ]
  }
}
