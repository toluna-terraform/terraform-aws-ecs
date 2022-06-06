#------------------------------------------
# data.tf
# Module: ECS
#------------------------------------------

# current AWS Region
data "aws_region" "current" {}

# vpce prefix list
data "aws_prefix_list" "private_s3" {
  name = "com.amazonaws.us-east-1.s3"
}


# Container definitions
data "template_file" "default-container" {

  template = file("${path.module}/templates/containers.json")
  vars = {
    region                 = data.aws_region.current.name
    log_group              = var.aws_cloudwatch_log_group_name
    cpu                    = var.default_container_cpu
    memory                 = var.default_container_memory
    container_port         = var.default_container_port
    name                   = "${var.app_name}-${var.environment}"
    image                  = "${var.ecr_repo_url}:${split("-", var.environment)[0]}"
    aspnetcore_environment = "${split("-", var.environment)[0]}"
    secret                 = "/infra/${var.app_name}-${var.environment}/db-host"
    awslogs-stream-prefix  = "awslogs-${var.app_name}-pref"
    create_datadog         = var.create_datadog
    dd_cpu                 = var.datadog_container_cpu
    dd_memory              = var.datadog_container_memory
    dd_container_port      = var.datadog_container_port
    dd_name                = var.datadog_container_name
    dd_image               = var.datadog_container_image
    dd_api_key             = var.dd_api_key
    dd_environment         = jsonencode(var.datadog_environment_variables)
  }
}
