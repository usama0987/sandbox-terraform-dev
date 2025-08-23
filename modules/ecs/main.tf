# [Previous resources omitted for brevity...]

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = var.platform_version

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.app.arn
  }

  deployment_maximum_percent        = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  deployment_circuit_breaker {
    enable   = var.enable_deployment_circuit_breaker
    rollback = var.enable_deployment_rollback
  }

  enable_execute_command = var.enable_execute_command

  depends_on = [var.target_group_arn]

  tags = {
    Name = "${var.name_prefix}-service"
  }
}

# [Remaining resources omitted...]
