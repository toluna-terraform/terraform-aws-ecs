locals {
  # ECS SG rules
  ecs_security_group_rules = {
    ingress_http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"] // We are protected by the VPC here so it is fine
    }

    ingress_all = {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      type      = "ingress"
      self      = true
    }

    egress_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress_vpce = {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      type            = "egress"
      prefix_list_ids = ["${data.aws_prefix_list.private_s3.id}"]
    }
  }

  default_iam_role_policies = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", 
                               "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
                               "arn:aws:iam::aws:policy/CloudWatchFullAccess"]

  dockerLabels                  = jsonencode(var.dockerLabels)
  app_container_environment     = jsonencode(var.app_container_environment)
  app_container_secrets         = jsonencode(var.app_container_secrets)
  app_container_ulimits         = jsonencode(var.app_container_ulimits)
  app_container_command         = jsonencode(var.app_container_command)
  datadog_container_secrets     = jsonencode(var.datadog_container_secrets)
  datadog_container_environment = jsonencode(var.datadog_container_environment)
  default-container             = templatefile("${path.module}/templates/containers.json", {
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
    ulimits               = local.app_container_ulimits == "[]" ? "null" : local.app_container_ulimits
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
  })
}
