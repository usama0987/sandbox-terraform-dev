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

resource "aws_security_group" "main" {
  name        = "${var.name_prefix}-alb-ecs-sg"
  description = "Security group for ECS and ALB in ${coalesce(var.environment, "dev-sandbox")}"
  vpc_id      = var.vpc_id

  # Ingress rules
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-alb-ecs-sg"
    Environment = coalesce(var.environment, "dev-sandbox")
  }
}
