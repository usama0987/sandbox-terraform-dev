variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev-sandbox)"
  type        = string
  default     = "dev-sandbox"
}
