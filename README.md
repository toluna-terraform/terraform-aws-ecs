<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.35.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.ecs_auto_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.datadog_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.datadog_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.that](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ecs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_prefix_list.private_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/prefix_list) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.current_service_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_container_command"></a> [app\_container\_command](#input\_app\_container\_command) | The command to pass to the app container | `list(string)` | `[]` | no |
| <a name="input_app_container_cpu"></a> [app\_container\_cpu](#input\_app\_container\_cpu) | Default container cpu | `number` | `2` | no |
| <a name="input_app_container_environment"></a> [app\_container\_environment](#input\_app\_container\_environment) | The environment variables to pass to a container | `list(map(string))` | `[]` | no |
| <a name="input_app_container_image"></a> [app\_container\_image](#input\_app\_container\_image) | App container image | `string` | n/a | yes |
| <a name="input_app_container_memory"></a> [app\_container\_memory](#input\_app\_container\_memory) | Default container memory | `number` | `4096` | no |
| <a name="input_app_container_port"></a> [app\_container\_port](#input\_app\_container\_port) | Default container port | `number` | `80` | no |
| <a name="input_app_container_secrets"></a> [app\_container\_secrets](#input\_app\_container\_secrets) | The secrets to pass to the app container | `list(map(string))` | `[]` | no |
| <a name="input_app_container_ulimits"></a> [app\_container\_ulimits](#input\_app\_container\_ulimits) | The ulimits to pass to the app container | `list` | `[]` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | app name | `string` | n/a | yes |
| <a name="input_autoscaling_cpu_target_percentage"></a> [autoscaling\_cpu\_target\_percentage](#input\_autoscaling\_cpu\_target\_percentage) | Auto-scaling AVG CPU Utilization target percentage | `number` | `null` | no |
| <a name="input_autoscaling_max_capacity"></a> [autoscaling\_max\_capacity](#input\_autoscaling\_max\_capacity) | Auto-scaling maximmum capacity | `number` | `null` | no |
| <a name="input_autoscaling_min_capacity"></a> [autoscaling\_min\_capacity](#input\_autoscaling\_min\_capacity) | Auto-scaling minimmum capacity | `number` | `null` | no |
| <a name="input_aws_alb_target_group_arn"></a> [aws\_alb\_target\_group\_arn](#input\_aws\_alb\_target\_group\_arn) | ALB target group arn | `string` | `null` | no |
| <a name="input_aws_cloudwatch_log_group_name"></a> [aws\_cloudwatch\_log\_group\_name](#input\_aws\_cloudwatch\_log\_group\_name) | Cloud watch log group name | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | profile | `string` | n/a | yes |
| <a name="input_create_datadog"></a> [create\_datadog](#input\_create\_datadog) | Boolean which initiate datadog container creation or not | `bool` | `false` | no |
| <a name="input_datadog_container_cpu"></a> [datadog\_container\_cpu](#input\_datadog\_container\_cpu) | Datadog container cpu | `number` | `10` | no |
| <a name="input_datadog_container_environment"></a> [datadog\_container\_environment](#input\_datadog\_container\_environment) | Datadog container environment variables | `list(map(string))` | `[]` | no |
| <a name="input_datadog_container_image"></a> [datadog\_container\_image](#input\_datadog\_container\_image) | Datadog container image | `string` | `"public.ecr.aws/datadog/agent:latest"` | no |
| <a name="input_datadog_container_memoryreservation"></a> [datadog\_container\_memoryreservation](#input\_datadog\_container\_memoryreservation) | Datadog container memory | `number` | `256` | no |
| <a name="input_datadog_container_name"></a> [datadog\_container\_name](#input\_datadog\_container\_name) | Datadog container name | `string` | `"datadog_agent"` | no |
| <a name="input_datadog_container_port"></a> [datadog\_container\_port](#input\_datadog\_container\_port) | Datadog container port | `number` | `8126` | no |
| <a name="input_datadog_container_secrets"></a> [datadog\_container\_secrets](#input\_datadog\_container\_secrets) | The secrets to pass to the datadog container | `list(map(string))` | `[]` | no |
| <a name="input_dockerLabels"></a> [dockerLabels](#input\_dockerLabels) | A key/value map of labels to add to the container | `map(string)` | `{}` | no |
| <a name="input_ecr_repo_url"></a> [ecr\_repo\_url](#input\_ecr\_repo\_url) | ecr repo url | `string` | n/a | yes |
| <a name="input_ecs_security_group_additional_rules"></a> [ecs\_security\_group\_additional\_rules](#input\_ecs\_security\_group\_additional\_rules) | List of additional security group rules to add to the security group created | `any` | `{}` | no |
| <a name="input_ecs_service_desired_count"></a> [ecs\_service\_desired\_count](#input\_ecs\_service\_desired\_count) | ecs service desired count | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | environment | `string` | n/a | yes |
| <a name="input_iam_role_additional_policies"></a> [iam\_role\_additional\_policies](#input\_iam\_role\_additional\_policies) | IAM Policy to be attached to role | `list(string)` | `[]` | no |
| <a name="input_is_auto_scaling_enabled"></a> [is\_auto\_scaling\_enabled](#input\_is\_auto\_scaling\_enabled) | A boolean flag to enable/disable auto-scaling features | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs used in Service | `list(string)` | `null` | no |
| <a name="input_task_definition_cpu"></a> [task\_definition\_cpu](#input\_task\_definition\_cpu) | Task definition CPU | `number` | `2048` | no |
| <a name="input_task_definition_memory"></a> [task\_definition\_memory](#input\_task\_definition\_memory) | Task definition memory | `number` | `4096` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | n/a |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | n/a |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | n/a |
| <a name="output_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#output\_ecs\_task\_execution\_role\_arn) | n/a |
| <a name="output_security_group_ecs_id"></a> [security\_group\_ecs\_id](#output\_security\_group\_ecs\_id) | n/a |
<!-- END_TF_DOCS -->