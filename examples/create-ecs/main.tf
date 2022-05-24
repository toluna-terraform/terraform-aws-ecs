module "example-ecs" {
  source                        = "../.."
  app_name                      = var.app_name
  environment                   = var.environment
  vpc_id                        = module.aws_vpc.attributes.vpc_id
  ecs_service_desired_count     = var.ecs_service_desired_count
  ecr_repo_url                  = var.ecr_repo_url
  aws_cloudwatch_log_group_name = var.aws_cloudwatch_log_group_name
  subnet_ids                    = module.aws_vpc.attributes.private_subnets
  aws_alb_target_group_arn      = var.aws_alb_target_group_arn
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
