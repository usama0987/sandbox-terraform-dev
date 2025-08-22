
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "sandbox-dev-terraform-statefiles"
    key    = "dev-sandbox/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "dev-sandbox"
      Project     = "ecs-infrastructure"
      ManagedBy   = "terraform"
    }
  }
}

# Local values for environment-specific configurations
locals {
  name_prefix = "dev-sandbox"
  environment = "dev-sandbox"
  region      = "us-east-1"

  # VPC Configuration
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # ECS Configuration
  container_image = "nginx:latest"
  container_port  = 5000
  desired_count   = 2
  task_cpu        = "512"
  task_memory     = "1024"

  # ALB Configuration
  health_check_path = "/"

  # ECR Configuration
  max_image_count     = 10
  untagged_image_days = 7

  # Environment variables for the container
  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = "dev-sandbox"
    },
    {
      name  = "PORT"
      value = "5000"
    }
  ]
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  name_prefix            = local.name_prefix
  vpc_cidr              = local.vpc_cidr
  public_subnet_cidrs   = local.public_subnet_cidrs
  private_subnet_cidrs  = local.private_subnet_cidrs
  enable_nat_gateway    = false
}

# Security Groups Module
module "security_groups" {
  source = "../../modules/security_groups"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
}

# ECR Repository Module
module "ecr" {
  source = "../../modules/ecr"

  name_prefix         = local.name_prefix
  image_tag_mutability = "MUTABLE"
  force_delete        = true
  scan_on_push        = true
  encryption_type     = "AES256"
  max_image_count     = local.max_image_count
  untagged_image_days = local.untagged_image_days
  allowed_principals  = []
}

# Application Load Balancer Module
module "alb" {
  source = "../../modules/alb"

  name_prefix                        = local.name_prefix
  vpc_id                            = module.vpc.vpc_id
  public_subnet_ids                 = module.vpc.public_subnet_ids
  security_group_ids                = [module.security_groups.alb_ecs_security_group_id]
  enable_deletion_protection        = false
  enable_http2                      = true
  idle_timeout                      = 60
  ssl_certificate_arn               = null
  health_check_enabled              = true
  health_check_healthy_threshold    = 2
  health_check_unhealthy_threshold  = 2
  health_check_timeout              = 5
  health_check_interval             = 30
  health_check_path                 = local.health_check_path
  health_check_matcher              = "200"
}

# ECS Cluster Module
module "ecs" {
  source = "../../modules/ecs"

  name_prefix                         = local.name_prefix
  vpc_id                             = module.vpc.vpc_id
  private_subnet_ids                 = module.vpc.private_subnet_ids
  security_group_ids                 = [module.security_groups.alb_ecs_security_group_id]
  target_group_arn                   = module.alb.target_group_arn
  task_execution_role_arn            = module.ecr.ecs_task_execution_role_arn
  task_role_arn                      = module.ecr.ecs_task_role_arn
  service_name                       = "app"
  container_name                     = "app"
  container_image                    = local.container_image
  container_port                     = local.container_port
  task_cpu                          = local.task_cpu
  task_memory                       = local.task_memory
  desired_count                     = local.desired_count
  platform_version                  = "LATEST"
  deployment_maximum_percent        = 200
  deployment_minimum_healthy_percent = 50
  enable_deployment_circuit_breaker = true
  enable_deployment_rollback        = true
  enable_execute_command            = false
  enable_container_insights         = true
  log_retention_days                = 7
  environment_variables             = local.environment_variables
  secrets                           = []
  enable_health_check               = false
}
