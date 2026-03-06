resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier        = var.db_identifier
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.db_security_group_ids

  publicly_accessible = false
  multi_az            = false
  storage_type        = "gp2"

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  storage_encrypted = true

  tags = {
    Name = var.db_identifier
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = var.secret_name

  tags = {
    Name = var.secret_name
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  depends_on = [aws_db_instance.this]

  secret_string = jsonencode({
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_ENDPOINT = aws_db_instance.this.address
    DB_NAME     = var.db_name
  })
}
