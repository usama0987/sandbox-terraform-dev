#############################
# Identity / Helpers
#############################
data "aws_caller_identity" "current" {}

# Build a non-empty list of valid AWS principals:
# - account root
# - the roles created in this module
# - any extras from var.allowed_principals (list(string), may be empty)
locals {
  base_principals = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
  ]
  role_principals = [
    aws_iam_role.ecs_task_execution_role.arn,
    aws_iam_role.ecs_task_role.arn,
  ]
  extra_principals = var.allowed_principals != null ? var.allowed_principals : []
  allowed_principals = compact(concat(local.base_principals, local.role_principals, local.extra_principals))
}

#############################
# ECR Repository
#############################
resource "aws_ecr_repository" "main" {
  name                 = "${var.name_prefix}-repository"
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key
  }

  tags = {
    Name = "${var.name_prefix}-repository"
  }
}

# Remove or comment out this resource
#############################
# ECR Repository Policy
#############################
# resource "aws_ecr_repository_policy" "main" {
#   repository = aws_ecr_repository.main.name
#   policy     = jsonencode({
#     Version   = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "AllowRepoAccessToAccountAndRoles"
#         Effect    = "Allow"
#         Principal = { AWS = local.allowed_principals }
#         Action = [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "ecr:PutImage",
#           "ecr:InitiateLayerUpload",
#           "ecr:UploadLayerPart",
#           "ecr:CompleteLayerUpload"
#         ]
#       }
#     ]
#   })
# }

#############################
# ECR Lifecycle Policy
#############################
resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_image_count} images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = var.max_image_count
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than ${var.untagged_image_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_image_days
        }
        action = { type = "expire" }
      }
    ]
  })
}

#############################
# IAM Roles
#############################
# Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name_prefix}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = {
    Name = "${var.name_prefix}-ecs-task-execution-role"
  }
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ecr_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Task Role (application runtime)
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name_prefix}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = {
    Name = "${var.name_prefix}-ecs-task-role"
  }
}
