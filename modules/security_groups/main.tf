
# Security Group for ALB and ECS
resource "aws_security_group" "alb_ecs" {
  name_prefix = "${var.name_prefix}-alb-ecs-"
  description = "Security group for ALB and ECS allowing ports 80, 443, and 5000"
  vpc_id      = var.vpc_id

  # Ingress rules for ALB
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Application port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for ECS to allow traffic from ALB on port 5000
  ingress {
    description = "ECS from ALB"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    self        = true
  }

  # Egress rule - allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-alb-ecs-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}
