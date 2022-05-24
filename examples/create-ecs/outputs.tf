output "cluster_name" {
  value = module.example-ecs.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.example-ecs.ecs_service_name
}

output "ecs_task_definition_arn" {
  value = module.example-ecs.ecs_task_definition_arn
}
