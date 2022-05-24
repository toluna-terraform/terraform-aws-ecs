variable "app_name" {
  description = "app name"
  type        = string
  default     = "terratest-ecs"
}

variable "environment" {
  description = "environment"
  type        = string
  default     = "non-prod"
}

variable "ecs_service_desired_count" {
  description = "ecs service desired count"
  type        = number
  default     = 1
}

variable "ecr_repo_url" {
  description = "ecr repo url"
  type        = string
  default     = "bitnami/node:latest"
}

variable "aws_cloudwatch_log_group_name" {
  description = "Cloud watch log group name"
  type        = string
  default     = "terratest-ecs"
}


variable "subnet_ids" {
  description = "Subnet IDs used in Service"
  type        = list(string)
  default     = null
}

variable "aws_alb_target_group_arn" {
  description = "ALB target group arn"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = null
}

variable "ecs_security_group_additional_rules" {
  description = "List of additional security group rules to add to the security group created"
  type        = any
  default     = {}
}
