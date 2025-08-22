# Security Group Module Outputs
output "security_group_id" {
  description = "ID of the shared security group"
  value       = aws_security_group.shared.id
}

output "security_group_arn" {
  description = "ARN of the shared security group"
  value       = aws_security_group.shared.arn
}

output "security_group_name" {
  description = "Name of the shared security group"
  value       = aws_security_group.shared.name
}
