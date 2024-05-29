## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.listener_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | An Access Logs block | <pre>list(object({<br>    bucket  = string<br>    prefix  = string<br>    enabled = bool<br>  }))</pre> | `[]` | no |
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | ALB arn | `string` | `""` | no |
| <a name="input_attach_certificate"></a> [attach\_certificate](#input\_attach\_certificate) | Indicate whether a new certificate needs to be attached | `bool` | `false` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | The ARN of the certificate to attach to the listener | `string` | `""` | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Create ALB | `bool` | `false` | no |
| <a name="input_create_alb_listener"></a> [create\_alb\_listener](#input\_create\_alb\_listener) | Create ALB Listener | `bool` | `false` | no |
| <a name="input_default_port"></a> [default\_port](#input\_default\_port) | Default port used across the listener and target group | `number` | `80` | no |
| <a name="input_default_protocol"></a> [default\_protocol](#input\_default\_protocol) | Default protocol used across the listener and target group | `string` | `"HTTP"` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. | `bool` | `true` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, the LB will be internal | `bool` | `false` | no |
| <a name="input_listener_arn"></a> [listener\_arn](#input\_listener\_arn) | The ARN of the listener to which to attach the rule | `string` | `""` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Map of listener configurations to create | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the LB | `string` | `""` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The list of security groups for ALB. | `list(any)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnet IDs to attach to the LB | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Map of target group configurations to create | `any` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | # All the below listed outputs returns value only when var.create\_alb is true, otherwise they return an empty string ("") |
| <a name="output_arn_suffix"></a> [arn\_suffix](#output\_arn\_suffix) | n/a |
| <a name="output_dns"></a> [dns](#output\_dns) | n/a |
| <a name="output_listeners"></a> [listeners](#output\_listeners) | n/a |
| <a name="output_target_groups"></a> [target\_groups](#output\_target\_groups) | n/a |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | # All the below listed outputs returns value only when var.create\_alb\_listener is true, otherwise they return an empty string ("") |

## License

Apache 2 Licensed. See [LICENSE](https://github.com/TechHoldingLLC/terraform-aws-alb/blob/main/LICENSE) for full details.