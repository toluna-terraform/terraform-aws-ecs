resource "aws_appautoscaling_target" "appautoscaling_target" {
  # if auto-scaling is enabled, than create the resource
  count = var.is_auto_scaling_enabled ? 1 : 0

  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_auto_scaling" {
  # if auto-scaling is enabled, than create the resource
  count = var.is_auto_scaling_enabled ? 1 : 0

  name               = "${var.app_name}-${var.environment}_auto_scaling_policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.appautoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.appautoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.appautoscaling_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling_cpu_target_percentage
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}