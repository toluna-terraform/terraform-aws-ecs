locals {
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

    egress = {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      prefix_list_ids = ["${data.aws_prefix_list.private_s3.id}"]
    }
  }
}
