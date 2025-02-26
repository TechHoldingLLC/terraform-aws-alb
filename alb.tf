#####################################
# alb/alb.tf  #
#####################################

#-------------To Create Application Load Balancer-------------#
resource "aws_lb" "alb" {
  count                      = var.create_alb ? 1 : 0
  name                       = var.name
  load_balancer_type         = "application"
  internal                   = var.internal
  idle_timeout               = var.idle_timeout
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = var.access_logs
    content {
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
      enabled = lookup(access_logs.value, "enabled", false)
    }
  }
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}