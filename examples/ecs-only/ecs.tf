locals {

  app_container_environment = [
    {
      "name" : "var_name",
      "value" : "var_value"
    }
  ]

  app_container_secrets = [
    {
      "name": "secret_name",
      "valueFrom": "ssm_path"
    }
  ]
    app_container_ulimits = [
    {
      "name": "nofile",
      "softLimit": 65536,
      "hardLimit": 65536
    }
  ]
  app_container_command = ["command"]
}


module "ecs" {
  source  = "toluna-terraform/ecs/aws"

  app_name                      = local.app_name
  environment                   = local.environment
  aws_profile                   = local.aws_profile
  vpc_id                        = local.vpc_id
  ecs_service_desired_count     = local.ecs_service_desired_count
  ecr_repo_url                  = local.ecr_repo_url
  aws_cloudwatch_log_group_name = local.aws_cloudwatch_log_group
  subnet_ids                    = local.subnet_ids
  aws_alb_target_group_arn      = local.aws_alb_target_group_arn
  app_container_environment     = local.app_container_environment
  app_container_secrets         = local.app_container_secrets
  app_container_ulimits         = local.app_container_ulimits
  app_container_command         = local.app_container_command
  app_container_image           = "image_url"
  task_definition_cpu           = 512
  task_definition_memory        = 4096
  app_container_memory          = 4096
  app_container_port            = 443
  ecs_security_group_additional_rules = {
    lb_access = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      type        = "ingress"
      source_security_group_id  = "sg_id"
    }
}

}
