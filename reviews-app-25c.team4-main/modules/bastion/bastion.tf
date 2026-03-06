data "aws_ssm_parameter" "al2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_security_group" "bastion_sg" {
  name   = "${var.name_prefix}-bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH from approved IPs only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    description = "Allow outbound (needed for yum + DB access)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-bastion-sg"
  }
}

# Allow Bastion to interact with the Database (RDS) on MySQL port
resource "aws_vpc_security_group_ingress_rule" "allow_bastion_to_db" {
  security_group_id            = var.db_sg_id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

# The Bastion EC2 Instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.al2_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile_name

  user_data = <<-EOF
              #!/bin/bash
              set -e

              yum update -y
              yum install -y mysql

              # Ensure ssh dir exists
              mkdir -p /home/ec2-user/.ssh
              touch /home/ec2-user/.ssh/authorized_keys

              %{for key in var.ssh_public_keys~}
              echo "${key}" >> /home/ec2-user/.ssh/authorized_keys
              %{endfor~}

              chown -R ec2-user:ec2-user /home/ec2-user/.ssh
              chmod 700 /home/ec2-user/.ssh
              chmod 600 /home/ec2-user/.ssh/authorized_keys
              EOF

  tags = {
    Name = "${var.name_prefix}-bastion"
  }
}
