####################################
# alb/listener_tg.tf #
####################################

locals {
  alb_arn = var.create_alb ? aws_lb.alb[0].arn : var.alb_arn # If ALB is created using this module, then ALB arn value is directly assigned from newly created ALB, otherwise the arn value is passed using the variable.
}

resource "aws_lb_listener" "listener" {
  count             = var.create_alb_listener ? 1 : 0
  load_balancer_arn = local.alb_arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = var.content_type
      message_body = var.message_body
      status_code  = var.status_code
    }
  }
}

################################
#  LISTENER CERTIFICATE #
################################

resource "aws_lb_listener_certificate" "listener_certificate" {
  count           = var.attach_certificate ? 1 : 0
  certificate_arn = var.certificate_arn
  listener_arn    = var.listener_arn
}

################################
#  TARGET GROUP  #
################################

## Target Group is needed for fixed-response action of listener
resource "aws_lb_target_group" "target_group" {
  count       = var.create_alb_listener ? 1 : 0
  name        = var.target_group_name
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  dynamic "stickiness" {
    for_each = var.stickiness
    content {
      type            = lookup(stickiness.value, "type", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
    }
  }

  dynamic "health_check" {
    for_each = [var.health_check]
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      timeout             = lookup(health_check.value, "timeout", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      port                = lookup(health_check.value, "port", null)
      protocol            = lookup(health_check.value, "protocol", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}