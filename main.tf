resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${var.environment}"
}

resource "aws_ecs_service" "main" {
  name                = "${var.app_name}-${var.environment}"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.task_definition.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = var.ecs_service_desired_count
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  network_configuration {
    security_groups  = var.security_group_ids
    subnets          = var.subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "${var.app_name}-${var.environment}"
    container_port   = 80
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
  family                   = "${var.app_name}-${var.environment}"
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      "essential" : true,
      "memory" : 2048,
      "name" : "${var.app_name}-${var.environment}",
      "cpu" : 2,
      "taskRoleArn" : aws_iam_role.ecs_task_execution_role,
      "image" : "${var.ecr_repo_url}:${split("-", var.environment)[0]}",
      "environment" : [
        { "name" : "ASPNETCORE_ENVIRONMENT", "value" : "${split("-", var.environment)[0]}" }
      ],
      "secrets" : [
        {
          "name" : "DB_HOST",
          "valueFrom" : "/infra/${var.app_name}-${var.environment}/db-host"
        }
      ],
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${var.aws_cloudwatch_log_group_name}",
          "awslogs-region" : "${data.aws_region.current.name}", // TODO: parametrized
          "awslogs-stream-prefix" : "awslogs-${var.app_name}-pref"
        }
      }
    }
  ])
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  cpu                = 512
  memory             = 2048
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "role-ecs-${var.app_name}-${var.environment}"
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

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ssm-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloud-watch-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}


# // ECS security group
resource "aws_security_group" "ecs_sg" {
  name   = "${var.environment}-${var.app_name}-ecs"
  vpc_id = var.vpc_id

  tags = {
    Name = "sg-${var.environment}-${var.app_name}-ecs"
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
