
output "repository_arn" {
  description = "Full ARN of the repository"
  value       = aws_ecr_repository.app.arn
}

output "repository_name" {
  description = "Name of the repository"
  value       = aws_ecr_repository.app.name
}

output "repository_url" {
  description = "URL of the repository"
  value       = aws_ecr_repository.app.repository_url
}

output "registry_id" {
  description = "Registry ID where the repository was created"
  value       = aws_ecr_repository.app.registry_id
}

output "repository_policy" {
  description = "The repository policy JSON"
  value       = aws_ecr_repository_policy.app.policy
}

output "lifecycle_policy" {
  description = "The lifecycle policy JSON"
  value       = aws_ecr_lifecycle_policy.app.policy
}
