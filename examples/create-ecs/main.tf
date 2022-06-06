locals {

  container_definitions = jsonencode([
    {
      "essential" : true,
      "memory" : 2048,
      "name" : "${var.app_name}-${var.environment}",
      "cpu" : 2,
      "taskRoleArn" : "${module.example-ecs.ecs_task_execution_role_arn}",
      "image" : "${var.ecr_repo_url}",
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
          "awslogs-region" : "us-east-1", // TODO: parametrized
          "awslogs-stream-prefix" : "awslogs-${var.app_name}-pref"
        }
      }
    }
  ])
}


module "example-ecs" {
  source                        = "../.."
  app_name                      = var.app_name
  environment                   = var.environment
  vpc_id                        = module.aws_vpc.attributes.vpc_id
  ecs_service_desired_count     = var.ecs_service_desired_count
  aws_cloudwatch_log_group_name = var.aws_cloudwatch_log_group_name
  subnet_ids                    = module.aws_vpc.attributes.private_subnets
  aws_alb_target_group_arn      = var.aws_alb_target_group_arn
  container_definitions         = local.container_definitions
}

module "aws_vpc" {
  source                = "toluna-terraform/vpc/aws"
  version               = "~>0.2.5"
  env_name              = "${var.app_name}-${var.environment}"
  env_type              = var.environment
  env_index             = 6
  number_of_azs         = 2
  create_tgw_attachment = false
  create_ecs_vpce       = false
  create_nat_instance   = true
}
