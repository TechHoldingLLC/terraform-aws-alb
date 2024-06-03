################################################################################
# Listener Rule(s)
################################################################################

output "listener_rule" {
  description = "Map of listeners rules created and their attributes"
  value       = aws_lb_listener_rule.this
}

################################################################################
# Target Group(s)
################################################################################

output "target_group" {
  description = "Map of target groups created and their attributes"
  value       = aws_lb_target_group.this
}