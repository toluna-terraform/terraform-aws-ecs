output "ecs_service_name" {
  value = aws_ecs_service.main.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "security_group_ecs_id" {
  value = aws_security_group.ecs_sg.id
}
