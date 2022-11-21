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
  app_container_command         = jsonencode(var.app_container_command)
  datadog_container_secrets     = jsonencode(var.datadog_container_secrets)
  datadog_container_environment = jsonencode(var.datadog_container_environment)
}
