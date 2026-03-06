# Frontend Custom AMI Creation (Nginx)

## Overview

This document describes the process used to create a custom **Amazon Linux 2023 AMI** that serves the frontend application using **Nginx**.

Two approaches were implemented:

1. **Manual AMI creation** using an EC2 instance.
2. **Automated AMI creation using Packer** (recommended approach).

The AMI will later be used by an **Auto Scaling Group (ASG)** for the frontend tier.
The AMI ID is stored in **AWS Systems Manager Parameter Store** so Terraform can retrieve it dynamically.

---

# Architecture Purpose

The goal of this AMI is to ensure that every instance launched by the Auto Scaling Group already contains:

* Amazon Linux 2023
* Nginx installed and configured
* Frontend application files
* Nginx configured to start automatically on boot

This allows new instances to become healthy and serve traffic immediately after launch.

---

# Part 1 — Manual AMI Creation

## 1. Launch EC2 Builder Instance

An EC2 instance was launched to configure the environment before creating the AMI.

### Configuration

| Setting        | Value                                 |
| -------------- | ------------------------------------- |
| AMI            | Amazon Linux 2023                     |
| Instance Type  | t3.micro                              |
| Security Group | SSH (22) from my IP                   |
|                | HTTP (80) from anywhere (for testing) |
| IAM Role       | None                                  |
| Key Pair       | Local SSH key                         |

---

## 2. Connect to the Instance

```bash
ssh -i key.pem ec2-user@<public-ip>
```

---

## 3. Install and Configure Nginx

```bash
sudo dnf update -y
sudo dnf install nginx -y

sudo systemctl start nginx
sudo systemctl enable nginx

systemctl status nginx
curl localhost
```

At this point the default Nginx welcome page is accessible.

---

## 4. Deploy the Frontend Application

Frontend files from the repository folder:

```
frontend/
```

were copied to the instance.

### Copy files

```bash
scp -i <key>.pem -r ./frontend/* ec2-user@<EC2_PUBLIC_IP>:/tmp/frontend/
```

### Replace Nginx content

```bash
sudo rm -rf /usr/share/nginx/html/*
sudo cp -r /tmp/frontend/* /usr/share/nginx/html/
sudo chown -R root:root /usr/share/nginx/html
sudo chmod -R 755 /usr/share/nginx/html
```

Reload nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

After this step, the frontend application loads instead of the default Nginx page.

---

## 5. Verify Nginx Starts on Boot

```bash
sudo systemctl enable nginx
systemctl is-enabled nginx
```

Reboot test:

```bash
sudo reboot
```

After reconnecting:

```bash
systemctl is-active nginx
curl localhost
```

---

## 6. Clean Instance Before Creating AMI

```bash
sudo dnf clean all
sudo rm -rf /tmp/*
sudo cloud-init clean || true
```

---

## 7. Create AMI

EC2 Console:

```
Instance → Actions → Image and templates → Create image
```

AMI name:

```
reviews-app-frontend-nginx-ami
```

Wait until the AMI state becomes **Available**.

---

## 8. Test the AMI

Launch a new EC2 instance using the created AMI.

Verification commands:

```bash
systemctl is-active nginx
curl localhost
```

Reboot verification:

```bash
sudo reboot
systemctl is-active nginx
curl localhost
```

The application loads successfully after reboot.

---

## 9. Store AMI ID in Parameter Store

Store the AMI ID:

```bash
aws ssm put-parameter \
  --name "/custom-amis/reviews-app/frontend-ami-id" \
  --type "String" \
  --value "ami-0e671058ba649bbf8" \
  --overwrite
```

Verify the value:

```bash
aws ssm get-parameter \
  --name "/custom-amis/reviews-app/frontend-ami-id" \
  --query "Parameter.Value" \
  --output text
```

Example output:

```
ami-0e671058ba649bbf8
```

---

# Part 2 — Automated AMI Creation Using Packer (Bonus)

To make the AMI creation process reproducible and automated, the same setup was implemented using **Packer**.

## Why Packer

Manual AMI creation works but is not easily reproducible.
Packer allows automated image creation with:

* repeatable builds
* version-controlled infrastructure
* reduced human error

---

## Packer Folder Structure

```
modules/frontend-ami-packer/
│
├── frontend-ami.pkr.hcl
├── scripts/
│   └── setup_frontend_nginx.sh
└── README.md
```
---

## Packer Provisioning

Packer performs the same configuration steps automatically:

1. Launch temporary EC2 instance
2. Install nginx
3. Copy frontend files
4. Enable nginx on boot
5. Create AMI
6. Destroy temporary builder instance

---
**Install Packer**: Follow the instructions on the [Packer Installation Guide](https://www.packer.io/downloads).
+
brew install jq


**Verify Installation**: You should see the installed version of Packer printed in the terminal. Make sure it matches the expected version required for your project.

   ```bash
   packer version
   ```

## Run Packer

```bash
cd modules/frontend-ami-packer

packer init .
packer validate .
packer build .
```

After the build completes, Packer outputs the created AMI ID.

---

## Automatically Store AMI ID

The Packer build also writes the AMI ID to Parameter Store automatically:

```bash
aws ssm put-parameter \
  --name "/custom-amis/reviews-app/frontend-ami-id" \
  --type String \
  --value "$AMI_ID" \
  --overwrite
```

This ensures Terraform always references the most recent AMI.

---

# Terraform Integration

Terraform retrieves the AMI dynamically from Parameter Store.

```hcl
data "aws_ssm_parameter" "frontend_ami" {
  name = "/custom-amis/reviews-app/frontend-ami-id"
}

image_id = data.aws_ssm_parameter.frontend_ami.value
```

This avoids hardcoding AMI IDs in Terraform.

---

# Result

The frontend AMI now contains:

* Amazon Linux 2023
* Nginx installed and configured
* Frontend static files
* Automatic startup on boot

The AMI ID is stored in Parameter Store and can be retrieved by Terraform when creating the Launch Template or Auto Scaling Group.

# Verification Steps

After building the AMI using **Packer**, the following checks were performed to verify that the image was created and configured correctly.

---

## 1. Confirm Packer Build Completed Successfully

At the end of a successful build, Packer outputs something similar to:

```
==> amazon-ebs.frontend: AMI: ami-xxxxxxxxxxxx
==> Build 'reviews-app-frontend-ami.amazon-ebs.frontend' finished.
```

If the build finishes successfully, it means the AMI was created.

---

## 2. Verify the AMI Exists in AWS

Navigate to:

```
AWS Console → EC2 → AMIs
```

Search for the AMI name:

```
reviews-app-frontend-nginx
```

You should see something similar to:

```
reviews-app-frontend-nginx-1719872342
```

The AMI status must be:

```
Available
```

---

## 3. Verify AMI ID in Parameter Store

Run the following command locally:

```
aws ssm get-parameter \
  --name "/custom-amis/reviews-app/frontend-ami-id" \
  --query "Parameter.Value" \
  --output text
```

Expected output:

```
ami-xxxxxxxxxxxx
```

This confirms that the **Packer post-processor successfully stored the AMI ID in AWS Systems Manager Parameter Store**.

---

## 4. Launch an Instance from the AMI

Navigate to:

```
AWS Console → EC2 → AMIs → Select AMI → Launch Instance
```

After launching, connect to the instance:

```
ssh -i key.pem ec2-user@<public-ip>
```

---

## 5. Verify Nginx is Running

Run the following command:

```
systemctl is-active nginx
```

Expected output:

```
active
```

---

## 6. Verify the Frontend Application

Run:

```
curl localhost
```

You should see the HTML output from the frontend application.

You can also open the instance public IP in a browser:

```
http://<public-ip>
```

---

## 7. Reboot Validation (Production Check)

To ensure the service starts automatically after reboot:

```
sudo reboot
```

After reconnecting:

```
systemctl is-active nginx
curl localhost
```

If the service remains active and the application loads correctly, the AMI is fully functional.

---

## 8. Verify Terraform Can Retrieve the AMI

Terraform retrieves the AMI dynamically from Parameter Store.

Example Terraform configuration:

```
data "aws_ssm_parameter" "frontend_ami" {
  name = "/custom-amis/reviews-app/frontend-ami-id"
}
```

You can verify this locally using the Terraform console:

```
terraform console
```

Then run:

```
data.aws_ssm_parameter.frontend_ami.value
```

Expected result:

```
ami-xxxxxxxxxxxx
```

This confirms that Terraform can dynamically retrieve the correct AMI ID.
