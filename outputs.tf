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
output "zone_id" {
  value = var.create_alb ? aws_lb.alb[0].zone_id : null
}

output "listeners" {
  value = aws_lb_listener.listener
}

output "target_groups" {
  value = aws_lb_target_group.target_group
}