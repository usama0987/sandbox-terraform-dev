variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ECS service"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = string
}

variable "task_memory" {
  description = "Memory for the task (in MiB)"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch logs (in days)"
  type        = number
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = list(map(string))
  default     = []
}

variable "enable_container_insights" {
  description = "Enable Container Insights"
  type        = bool
  default     = false
}

variable "enable_health_check" {
  description = "Enable health check"
  type        = bool
  default     = false
}

variable "health_check_command" {
  description = "Health check command"
  type        = list(string)
  default     = []
}

variable "health_check_interval" {
  description = "Health check interval (in seconds)"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout (in seconds)"
  type        = number
  default     = 5
}

variable "health_check_retries" {
  description = "Health check retries"
  type        = number
  default     = 3
}

variable "health_check_start_period" {
  description = "Health check start period (in seconds)"
  type        = number
  default     = 0
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "platform_version" {
  description = "Fargate platform version"
  type        = string
  default     = "1.4.0"
}

variable "deployment_maximum_percent" {
  description = "Maximum percent for deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percent for deployment"
  type        = number
  default     = 100
}

variable "enable_deployment_circuit_breaker" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = false
}

variable "enable_deployment_rollback" {
  description = "Enable deployment rollback"
  type        = bool
  default     = false
}

variable "enable_execute_command" {
  description = "Enable execute command"
  type        = bool
  default     = false
}

variable "service_name" {
  description = "Name of the service discovery service"
  type        = string
  default     = "app"
}

variable "secrets" {
  description = "Secrets for the container"
  type        = list(map(string))
  default     = []
}

variable "task_execution_role_arn" {
  description = "ARN of the task execution role (optional, will be created if null)"
  type        = string
  default     = null
}

variable "task_role_arn" {
  description = "ARN of the task role (optional, will be created if null)"
  type        = string
  default     = null
}

variable "max_capacity" {
  description = "Maximum capacity for auto-scaling"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Minimum capacity for auto-scaling"
  type        = number
  default     = 1
}

variable "cpu_target_value" {
  description = "Target CPU utilization for auto-scaling"
  type        = number
  default     = 70
}

variable "memory_target_value" {
  description = "Target memory utilization for auto-scaling"
  type        = number
  default     = 80
}
