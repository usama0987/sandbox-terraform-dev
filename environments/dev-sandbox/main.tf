# AWS Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "dev-sandbox"
      Project     = "dev-sandbox-ecs-infrastructure"
      ManagedBy   = "terraform"
      Owner       = "dev-team"
      CostCenter  = "development"
    }
  }
}

# Local values for environment-specific configurations
locals {
  name_prefix = "dev-sandbox"
  environment = "dev-sandbox"
  region      = "us-east-1"

  # VPC Configuration - Multi-AZ setup
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  # ECR Configuration
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  max_image_count      = 10
  untagged_image_days  = 7

  # ECS Configuration with Auto Scaling
  task_cpu           = "512"
  task_memory        = "1024"
  desired_count      = 1
  min_capacity       = 1
  max_capacity       = 2
  log_retention_days = 7
  container_name     = "app"
  container_port     = 5000

  # Auto Scaling Configuration
  cpu_target_value    = 70
  memory_target_value = 80

  # Application Configuration
  container_image = "${module.ecr.repository_url}:latest"
  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = "dev-sandbox"
    },
    {
      name  = "LOG_LEVEL"
      value = "DEBUG"
    },
    {
      name  = "PORT"
      value = "5000"
    }
  ]

  # ALB Configuration
  health_check_path = "/health"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = local.name_prefix
  vpc_cidr             = local.vpc_cidr
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}

# Security Group Module
module "security_group" {
  source = "../../modules/security_groups"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
}

# ECR Module
module "ecr" {
  source = "../../modules/ecr"

  name_prefix          = local.name_prefix
  image_tag_mutability = local.image_tag_mutability
  scan_on_push         = local.scan_on_push
  encryption_type      = "AES256"
  force_delete         = true
  max_image_count      = local.max_image_count
  untagged_image_days  = local.untagged_image_days
  allowed_principals   = ["arn:aws:iam::527213286309:role/YourPushRole"] # Replace with actual IAM role ARN
}

# Application Load Balancer Module
module "alb" {
  source = "../../modules/alb"

  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids         = [module.security_group.security_group_id]
  health_check_path          = local.health_check_path
  ssl_policy                 = local.ssl_policy
  enable_deletion_protection = false
}

# ECS Module with Multi-AZ Auto Scaling
module "ecs" {
  source = "../../modules/ecs"

  name_prefix                        = local.name_prefix
  vpc_id                             = module.vpc.vpc_id
  private_subnet_ids                 = module.vpc.private_subnet_ids
  security_group_ids                 = [module.security_group.security_group_id]
  target_group_arn                   = module.alb.target_group_arn
  container_image                    = local.container_image
  task_cpu                           = local.task_cpu
  task_memory                        = local.task_memory
  desired_count                      = local.desired_count
  min_capacity                       = local.min_capacity
  max_capacity                       = local.max_capacity
  cpu_target_value                   = local.cpu_target_value
  memory_target_value                = local.memory_target_value
  log_retention_days                 = local.log_retention_days
  environment_variables              = local.environment_variables
  enable_container_insights          = true
  enable_health_check                = true
  health_check_command               = ["CMD-SHELL", "curl -f http://localhost:${local.container_port}/health || exit 1"]
  health_check_interval              = 30
  health_check_timeout               = 5
  health_check_retries               = 3
  health_check_start_period          = 60
  container_name                     = local.container_name
  container_port                     = local.container_port
  platform_version                   = "1.4.0"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  enable_deployment_circuit_breaker  = true
  enable_deployment_rollback         = true
  enable_execute_command             = false
  
  # Use IAM roles from ECR module to avoid conflicts
  task_execution_role_arn             = module.ecr.ecs_task_execution_role_arn
  task_role_arn                      = module.ecr.ecs_task_role_arn
}
