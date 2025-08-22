resource "aws_security_group" "main" {
  name        = "${var.name_prefix}-sg"
  description = "Security group for ECS and ALB in ${coalesce(var.environment, "dev-sandbox")}"
  vpc_id      = var.vpc_id

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-sg"
    Environment = coalesce(var.environment, "dev-sandbox")
  }
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}
