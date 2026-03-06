data "aws_caller_identity" "current" {}

resource "aws_iam_role" "shared_admin_role" {
  name = "Feature-C25T4-150-shared-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = [for id in var.teammate_ids : "arn:aws:iam::${id}:root"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_access" {
  role       = aws_iam_role.shared_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}