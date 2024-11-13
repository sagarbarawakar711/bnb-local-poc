resource "aws_ecs_service" "data_sync_service" {
  name            = local.service_full_name
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_definition.arn

  enable_ecs_managed_tags = true
  scheduling_strategy     = "REPLICA"
  propagate_tags          = "SERVICE"
  tags                    = var.common_tags

  desired_count                      = local.task_min_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  #health_check_grace_period_seconds  = 300
  force_new_deployment  = false
  wait_for_steady_state = false

  # https://www.terraform.io/docs/providers/aws/r/ecs_service.html#iam_role
  #iam_role = aws_iam_role.data_sync_role.arn

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
    base              = 0
  }

  # https://www.terraform.io/docs/providers/aws/r/ecs_service.html#ordered_placement_strategy-1
  dynamic "ordered_placement_strategy" {
    for_each = var.task_placement_strategy_rules
    content {
      type  = ordered_placement_strategy.value["type"]
      field = ordered_placement_strategy.value["field"]
    }
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_policy_attachment]
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      desired_count,
      task_definition,
      capacity_provider_strategy
    ]
  }
}

# https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_group.html
resource "aws_cloudwatch_log_group" "default" {
  name = local.service_full_name
  tags = var.common_tags

  # Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653.
  retention_in_days = 30
}


