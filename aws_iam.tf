# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "role-acesso-ssm"
resource "aws_iam_instance_profile" "role-acesso-ssm" {
  name = "role-acesso-ssm"
  path = "/"
  role = aws_iam_role.role-acesso-ssm.name
}

resource "aws_iam_role" "role-acesso-ssm" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description = "Allows EC2 instances to call AWS services on your behalf."
  force_detach_policies = false
  max_session_duration = 3600
  name = "role-acesso-ssm"
  path = "/"
}

resource "aws_iam_role_policy_attachment" "admin_access" {
  role       = aws_iam_role.role-acesso-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_access" {
  role       = aws_iam_role.role-acesso-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_access" {
  role       = aws_iam_role.role-acesso-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_core_access" {
  role       = aws_iam_role.role-acesso-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "secrets_manager_access" {
  role       = aws_iam_role.role-acesso-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy" "policy-get-secret-rds-bia" {
  role = aws_iam_role.role-acesso-ssm.name
  name = "policy-get-secret-rds-bia"
  policy = jsonencode({
    Statement = [{
      Action   = ["kms:Decrypt", "secretsmanager:GetSecretValue"]
      Effect   = "Allow"
      Resource = ["arn:aws:secretsmanager:us-east-1:471112700544:secret:rds/db-571f52ca-2fd4-4cf8-ac7f-60a298afe275-WKoDrz"]
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy" "policy-acesso-ssm-dos" {
  role = aws_iam_role.role-acesso-ssm.name
  name = "policy-acesso-ssm-dos"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ssm:DescribeInstanceInformation",
        "ssm:SendCommand",
        "ssm:CreateDocument",
        "ssmmessages:OpenDataChannel",
        "ssmmessages:OpenControlChannel"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}