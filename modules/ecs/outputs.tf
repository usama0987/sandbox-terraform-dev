output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.app.id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.app.arn # Corrected to use .arn instead of .id
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.app.arn
}

output "task_definition_family" {
  description = "Family of the task definition"
  value       = aws_ecs_task_definition.app.family
}

output "task_definition_revision" {
  description = "Revision of the task definition"
  value       = aws_ecs_task_definition.app.revision
}

output "service_discovery_namespace_id" {
  description = "ID of the service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "service_discovery_namespace_arn" {
  description = "ARN of the service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.main.arn
}

output "service_discovery_namespace_hosted_zone" {
  description = "Hosted zone ID of the service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.main.hosted_zone
}

output "service_discovery_service_id" {
  description = "ID of the service discovery service"
  value       = aws_service_discovery_service.app.id
}

output "service_discovery_service_arn" {
  description = "ARN of the service discovery service"
  value       = aws_service_discovery_service.app.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_logs.arn
}

output "task_execution_role_arn" {
  description = "ARN of the task execution role"
  value       = length(aws_iam_role.task_execution_role) > 0 ? aws_iam_role.task_execution_role[0].arn : var.task_execution_role_arn
}

output "task_role_arn" {
  description = "ARN of the task role"
  value       = length(aws_iam_role.task_role) > 0 ? aws_iam_role.task_role[0].arn : var.task_role_arn
}
