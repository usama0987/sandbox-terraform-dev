# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = module.vpc.availability_zones
}

# Security Group Outputs
output "alb_ecs_security_group_id" {
  description = "ID of the ALB and ECS security group"
  value       = module.security_group.security_group_id
}

# ECR Outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

# ECS Outputs
output "task_execution_role_arn" {
  description = "ARN of the task execution role"
  value       = module.ecs.task_execution_role_arn
}

output "task_role_arn" {
  description = "ARN of the task role"
  value       = module.ecs.task_role_arn
}

output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = module.ecs.service_id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = module.ecs.task_definition_arn
}

output "service_discovery_namespace_id" {
  description = "ID of the service discovery namespace"
  value       = module.ecs.service_discovery_namespace_id
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.ecs.cloudwatch_log_group_name
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer"
  value       = module.alb.alb_zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.alb.target_group_arn
}

# Application Access URLs
output "application_urls" {
  description = "URLs to access the application"
  value = {
    http_url   = "http://${module.alb.alb_dns_name}"
    direct_url = "http://${module.alb.alb_dns_name}:${local.container_port}"
  }
}

# Environment Information
output "environment_info" {
  description = "Environment configuration information"
  value = {
    environment   = "dev-sandbox"
    region        = "us-east-1"
    vpc_cidr      = local.vpc_cidr
    desired_count = local.desired_count
    task_cpu      = local.task_cpu
    task_memory   = local.task_memory
  }
}
