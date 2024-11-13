# https://www.terraform.io/docs/providers/aws/r/appautoscaling_target.html
resource "aws_appautoscaling_target" "ecs_data_sync_target" {
  min_capacity = local.task_min_count
  max_capacity = local.task_max_count
  resource_id  = local.ecs_resource_id

  # https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html#scalable_dimension
  # https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#autoscaling-RegisterScalableTarget-request-ScalableDimension
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# ------------------------------------------------------------------------------

# https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html
resource "aws_appautoscaling_policy" "cpu_data_sync_scale_policy" {
  name        = "cpu-scaling-${local.service_full_name_without_account}"
  policy_type = "TargetTrackingScaling"
  resource_id = local.ecs_resource_id

  # https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html#scalable_dimension
  # https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#autoscaling-RegisterScalableTarget-request-ScalableDimension
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  # https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html#target_tracking_scaling_policy_configuration-1
  target_tracking_scaling_policy_configuration {

    # https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html#predefined_metric_specification-1
    # https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PredefinedMetricSpecification.html
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.task_cpu_target_percent
    scale_in_cooldown  = 300
    scale_out_cooldown = 120
  }

  depends_on = [
    aws_appautoscaling_target.ecs_data_sync_target,
  ]
}

# https://www.terraform.io/docs/providers/aws/d/arn.html
data "aws_arn" "cpu_scale_policy" {
  arn = aws_appautoscaling_policy.cpu_data_sync_scale_policy.arn
}

# ------------------------------------------------------------------------------

# https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html
resource "aws_appautoscaling_policy" "memory_data_sync_scale_policy" {
  name        = "memory-scaling-${local.service_full_name_without_account}"
  policy_type = "TargetTrackingScaling"
  resource_id = local.ecs_resource_id

  # https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html#scalable_dimension
  # https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#autoscaling-RegisterScalableTarget-request-ScalableDimension
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  # https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html#target_tracking_scaling_policy_configuration-1
  target_tracking_scaling_policy_configuration {

    # https://www.terraform.io/docs/providers/aws/r/appautoscaling_policy.html#predefined_metric_specification-1
    # https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PredefinedMetricSpecification.html
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.task_memory_target_percent
    scale_in_cooldown  = 300
    scale_out_cooldown = 120
  }

  depends_on = [
    aws_appautoscaling_target.ecs_data_sync_target,
  ]
}

# https://www.terraform.io/docs/providers/aws/d/arn.html
data "aws_arn" "memory_data_sync_scale_policy" {
  arn = aws_appautoscaling_policy.memory_data_sync_scale_policy.arn
}
