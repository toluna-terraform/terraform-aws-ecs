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

# current account id
data "aws_caller_identity" "current" {}

#check if initial image exists
data "external" "current_service_image" {
  program = ["${path.module}/files/get_container_image.sh"]
  query = {
    app_name = "${var.app_name}"
    image_name = "${var.app_container_image}"
    aws_profile = "${var.aws_profile}"
  }
}

# Container definitions
data "template_file" "default-container" {

  template = file("${path.module}/templates/containers.json")
  vars = {
    region                = data.aws_region.current.name
    log_group             = var.aws_cloudwatch_log_group_name
    cpu                   = var.app_container_cpu
    memory                = var.app_container_memory
    container_port        = var.app_container_port
    dockerLabels          = local.dockerLabels == "{}" ? "null" : local.dockerLabels
    task_execution_role   = aws_iam_role.ecs_task_execution_role.arn
    name                  = "${var.app_name}-${local.env_name}"
    image                 = data.external.current_service_image.result.image
    environment           = local.app_container_environment == "[]" ? "null" : local.app_container_environment
    secrets               = local.app_container_secrets == "[]" ? "null" : local.app_container_secrets
    command               = local.app_container_command == "[]" ? "null" : local.app_container_command
    awslogs-stream-prefix = "awslogs-${var.app_name}-pref"
    create_datadog        = var.create_datadog
    dd_cpu                = var.datadog_container_cpu
    dd_memory             = var.datadog_container_memoryreservation
    dd_container_port     = var.datadog_container_port
    dd_name               = var.datadog_container_name
    dd_image              = var.datadog_container_image
    dd_api_key            = "/${data.aws_caller_identity.current.account_id}/datadog/api-key"
    dd_environment        = local.datadog_container_environment == "[]" ? "null" : local.datadog_container_environment
    dd_secrets            = local.datadog_container_secrets == "[]" ? "null" : local.datadog_container_secrets
  }
}
