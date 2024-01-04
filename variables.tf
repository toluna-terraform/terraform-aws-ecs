# General variables for module
variable "app_name" {
  description = "app name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "aws_profile" {
  description = "profile"
  type        = string
}

variable "ecs_service_desired_count" {
  description = "ecs service desired count"
  type        = number
}

variable "ecr_repo_url" {
  description = "ecr repo url"
  type        = string
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
}

variable "ecs_security_group_additional_rules" {
  description = "List of additional security group rules to add to the security group created"
  type        = any
  default     = {}
}

# variable "iam_role_additional_policies" {
#   description = "Additional policies to be added to the IAM role"
#   type        = list(string)
#   default     = []
# }

variable "iam_role_additional_policies" {
  description = "IAM Policy to be attached to role"
  type        = list(string)
  default     = []
}

variable "task_definition_cpu" {
  description = "Task definition CPU"
  type        = number
  default     = 2048
}

variable "task_definition_memory" {
  description = "Task definition memory"
  type        = number
  default     = 4096
}

# Default container related variables
variable "app_container_cpu" {
  description = "Default container cpu"
  type        = number
  default     = 2
}

variable "app_container_memory" {
  description = "Default container memory"
  type        = number
  default     = 4096
}

variable "app_container_port" {
  description = "Default container port"
  type        = number
  default     = 80
}

variable "aws_cloudwatch_log_group_name" {
  description = "Cloud watch log group name"
  type        = string
}

variable "app_container_environment" {
  description = "The environment variables to pass to a container"
  type        = list(map(string))
  default     = []
}

variable "dockerLabels" {
  description = "A key/value map of labels to add to the container"
  type        = map(string)
  default     = {}
}

variable "app_container_secrets" {
  description = "The secrets to pass to the app container"
  type        = list(map(string))
  default     = []
}
variable "app_container_ulimits" {
  description = "The ulimits to pass to the app container"
  type        = list
  default     = []
}
variable "app_container_command" {
  description = "The command to pass to the app container"
  type        = list(string)
  default     = []
}

variable "app_container_image" {
  description = "App container image"
  type        = string
}

# Datadog container related variables
variable "create_datadog" {
  description = "Boolean which initiate datadog container creation or not"
  type        = bool
  default     = false
}
variable "datadog_container_cpu" {
  description = "Datadog container cpu"
  type        = number
  default     = 10
}

variable "datadog_container_memoryreservation" {
  description = "Datadog container memory"
  type        = number
  default     = 256
}

variable "datadog_container_port" {
  description = "Datadog container port"
  type        = number
  default     = 8126
}

variable "datadog_container_name" {
  description = "Datadog container name"
  type        = string
  default     = "datadog_agent"
}

variable "datadog_container_image" {
  description = "Datadog container image"
  type        = string
  default     = "public.ecr.aws/datadog/agent:latest"
}

variable "datadog_container_environment" {
  description = "Datadog container environment variables"
  type        = list(map(string))
  default     = []
}

variable "datadog_container_secrets" {
  description = "The secrets to pass to the datadog container"
  type        = list(map(string))
  default     = []
}
