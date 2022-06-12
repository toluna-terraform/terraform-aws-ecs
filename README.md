# terraform-aws-ecs
Toluna terraform module for AWS ECS

## Description
This module creates an ECS cluster, ECS service, Task definition and IAM role for task excution.

## Usage
```hcl
module "ecs" {
  source                = "toluna-terraform/terraform-aws-ecs"
  version               = "~>0.0.1" // Change to the required version.
  app_name                      = local.app_name
  environment                   = local.environment
  vpc_id                        = local.vpc_id
  ecs_service_desired_count     = local.env_vars.ecs_service_desired_count
  ecr_repo_url                  = local.ecr_repo_url
  aws_cloudwatch_log_group_name = local.aws_cloudwatch_log_group
  subnet_ids                    = local.subnet_ids
  aws_alb_target_group_arn      = local.aws_alb_target_group_arn
  create_datadog                = true (default is false)
  datadog_environment           = [{ "name" : "ECS_FARGATE", "value" : "true" },]
}
```