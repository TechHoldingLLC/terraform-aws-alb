##################
# ALB OUTPUTS #
##################

## All the below listed outputs returns value only when var.create_alb is true, otherwise they return an empty string ("")
output "arn" {
  value = var.create_alb ? aws_lb.alb[0].arn : ""
}

output "arn_suffix" {
  value = var.create_alb ? aws_lb.alb[0].arn_suffix : ""
}

output "dns" {
  value = var.create_alb ? aws_lb.alb[0].dns_name : ""
}

###########################################
#  ALB LISTENER AND TARGET GROUP OUTPUT  #
###########################################

## All the below listed outputs returns value only when var.create_alb_listener is true, otherwise they return an empty string ("")
output "port" {
  value = var.create_alb_listener ? aws_lb_listener.listener[0].port : ""
}

output "target_group_arn" {
  value = var.create_alb_listener ? aws_lb_target_group.target_group[0].arn : ""
}

output "target_group_arn_suffix" {
  value = var.create_alb_listener ? aws_lb_target_group.target_group[0].arn_suffix : ""
}