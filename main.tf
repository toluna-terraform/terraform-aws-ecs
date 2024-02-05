locals {
  app_name               = var.app_name == null ? var.ecs_config.app_name : var.app_name
  ecr_repo_url           = var.ecr_repo_url == null ? var.ecs_config.ecr_repo_url : var.ecr_repo_url
  aws_profile            = var.aws_profile == null ? var.ecs_config.aws_profile : var.aws_profile
  environment            = var.environment == null ? var.ecs_config.environment : var.environment
  env_name               = var.environment == null ? var.ecs_config.env_name : split("-",local.environment)[0]
  vpc_id                 = var.vpc_id == null ? var.ecs_config.vpc_id : var.vpc_id
  subnet_ids             = var.subnet_ids == null ? var.ecs_config.subnet_ids : var.subnet_ids
  app_container_image    = var.app_container_image == null ? var.ecs_config.app_container_image : var.app_container_image
  task_definition_cpu    = var.task_definition_cpu != var.ecs_config.task_definition_cpu ? var.task_definition_cpu : var.ecs_config.task_definition_cpu
  task_definition_memory = var.task_definition_memory != var.ecs_config.task_definition_memory ? var.task_definition_memory : var.ecs_config.task_definition_memory
  app_container_memory   = var.app_container_memory != var.ecs_config.app_container_memory ? var.app_container_memory : var.ecs_config.app_container_memory
  ecs_service_desired_count = var.ecs_service_desired_count == null ? var.ecs_config.ecs_service_desired_count : var.ecs_service_desired_count
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.app_name}-${local.environment}"
}

resource "aws_cloudwatch_log_group" "datadog_log_group" {
  count = var.create_datadog ? 1 : 0
  name  = "${var.aws_cloudwatch_log_group_name}-datadog-agent"

  tags = {
    Environment = local.environment
    Application = local.app_name
  }
}

resource "aws_ecs_service" "main" {
  name                = "${local.app_name}-${local.environment}"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.task_definition.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = local.ecs_service_desired_count

  dynamic "deployment_controller" {
    for_each = var.aws_alb_target_group_arn == null ? [] : [true]
    content {
      type = "CODE_DEPLOY"
    }
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = local.subnet_ids
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = var.aws_alb_target_group_arn == null ? [] : [true]
    content {
      target_group_arn = var.aws_alb_target_group_arn
      container_name   = "${local.app_name}-${local.env_name}"
      container_port   = var.app_container_port
    }
  }

  deployment_circuit_breaker {
    enable   = var.aws_alb_target_group_arn == null ? true : false
    rollback = true
  }

  # Ignoring changes made by code_deploy controller
  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer,
    ]
  }
}


resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${local.app_name}-${local.env_name}"
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.default-container.rendered
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = local.task_definition_cpu
  memory                   = local.task_definition_memory
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "role-ecs-${local.app_name}-${local.environment}"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": [
         "ecs-tasks.amazonaws.com",
         "ssm.amazonaws.com",
         "mediastore.amazonaws.com"
         ]
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.ecs_task_execution_role.name
  for_each   = { for i, val in local.default_iam_role_policies : i => val }
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "that" {
  depends_on = [var.iam_role_additional_policies]
  role       = aws_iam_role.ecs_task_execution_role.name
  for_each   = { for i, val in var.iam_role_additional_policies : i => val }
  policy_arn = each.value
}

resource "aws_iam_role_policy" "datadog_policy" {
  name = "datadog-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ecs:ListClusters",
          "ecs:ListContainerInstances",
          "ecs:DescribeContainerInstances"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

# // ECS security group
resource "aws_security_group" "ecs_sg" {
  name   = "${local.environment}-${local.app_name}-ecs"
  vpc_id = local.vpc_id

  tags = {
    Name = "sg-${local.environment}-${local.app_name}-ecs"
  }
}

resource "aws_security_group_rule" "ecs_sg" {
  for_each = { for k, v in merge(local.ecs_security_group_rules, var.ecs_security_group_additional_rules) : k => v }

  # Required
  security_group_id = aws_security_group.ecs_sg.id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description              = try(each.value.description, null)
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, [])
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}
