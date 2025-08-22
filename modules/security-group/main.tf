# Security Group Module
# Shared security group for ALB and ECS
resource "aws_security_group" "shared" {
  name_prefix = "${var.name_prefix}-shared-"
  description = "Shared security group for ALB and ECS"
  vpc_id      = var.vpc_id

  # HTTP inbound rule
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS inbound rule
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port inbound rule
  ingress {
    description = "Application Port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow communication within the security group
  ingress {
    description = "Self Reference"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # All outbound traffic
  egress {
    description = "All Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-shared-sg"
    Environment = var.environment
    Purpose     = "Shared security group for ALB and ECS"
  }

  lifecycle {
    create_before_destroy = true
  }
}
