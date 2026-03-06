# Auto-discover AZs 
data "aws_availability_zones" "available" {
  state = "available"
}

# ==============================================
#                     VPC
# ==============================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

# ==============================================
#               Internet Gateway
# ==============================================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

# ==============================================
#               Route table
# ==============================================

# Public RT: default route to Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# Private RT: (no NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ==============================================
#                  Subnets
# ==============================================

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch_for_public_subnet

  tags = {
    Name = "${var.name_prefix}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch_for_private_subnet

  tags = {
    Name = "${var.name_prefix}-private-${count.index + 1}"
  }
}


# ==============================================
#              Security group
# ==============================================

# ALB SG
resource "aws_security_group" "alb_sg" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB ingress from internet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.alb_http_port
  to_port           = var.alb_http_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  count             = var.enable_https ? 1 : 0
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.alb_https_port
  to_port           = var.alb_https_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}



# Frontend SG (inbound only from ALB)
resource "aws_security_group" "frontend_app_sg" {
  name        = "${var.name_prefix}-frontend-sg"
  description = "Frontend instances allow inbound only from ALB"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "${var.name_prefix}-frontend-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "frontend_from_alb" {
  security_group_id            = aws_security_group.frontend_app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.frontend_port
  to_port                      = var.frontend_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "frontend_all_out" {
  security_group_id = aws_security_group.frontend_app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# Backend SG (inbound only from ALB)
resource "aws_security_group" "backend_app_sg" {
  name        = "${var.name_prefix}-backend-sg"
  description = "Backend instances allow inbound only from ALB"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "${var.name_prefix}-backend-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id            = aws_security_group.backend_app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.backend_app_port
  to_port                      = var.backend_app_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "backend_all_out" {
  security_group_id = aws_security_group.backend_app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}



# DB SG (allow only from backend)
resource "aws_security_group" "db_sg" {
  name        = "${var.name_prefix}-db-sg"
  description = "DB allows access only from backend"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "${var.name_prefix}-db-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "db_from_backend" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.backend_app_sg.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db_all_out" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
