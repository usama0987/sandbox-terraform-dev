
# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2              = var.enable_http2
  idle_timeout              = var.idle_timeout

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

# Target Group for port 5000
resource "aws_lb_target_group" "app" {
  name     = "${var.name_prefix}-app-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    matcher             = var.health_check_matcher
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = {
    Name = "${var.name_prefix}-app-tg"
  }
}

# Listener for port 80 (HTTP) - redirects to HTTPS if SSL certificate is provided
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.ssl_certificate_arn != null ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.ssl_certificate_arn != null ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.ssl_certificate_arn == null ? [1] : []
      content {
        target_group {
          arn = aws_lb_target_group.app.arn
        }
      }
    }
  }

  tags = {
    Name = "${var.name_prefix}-http-listener"
  }
}

# Listener for port 443 (HTTPS) - only created if SSL certificate is provided
resource "aws_lb_listener" "https" {
  count = var.ssl_certificate_arn != null ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name = "${var.name_prefix}-https-listener"
  }
}

# Listener for port 5000 (direct access to application)
resource "aws_lb_listener" "app_direct" {
  load_balancer_arn = aws_lb.main.arn
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name = "${var.name_prefix}-app-direct-listener"
  }
}
