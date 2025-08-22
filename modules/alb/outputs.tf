
output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_id" {
  description = "ID of the target group"
  value       = aws_lb_target_group.app.id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

output "http_listener_id" {
  description = "ID of the HTTP listener"
  value       = aws_lb_listener.http.id
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_id" {
  description = "ID of the HTTPS listener (if created)"
  value       = var.certificate_arn != null ? aws_lb_listener.https[0].id : null
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener (if created)"
  value       = var.certificate_arn != null ? aws_lb_listener.https[0].arn : null
}
