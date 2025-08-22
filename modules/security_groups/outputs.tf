
output "alb_ecs_security_group_id" {
  description = "ID of the ALB and ECS security group"
  value       = aws_security_group.alb_ecs.id
}

output "alb_ecs_security_group_arn" {
  description = "ARN of the ALB and ECS security group"
  value       = aws_security_group.alb_ecs.arn
}
