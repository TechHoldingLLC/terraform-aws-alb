######################
# alb/listener_tg.tf #
######################

locals {
  alb_arn = var.create_alb ? aws_lb.alb[0].arn : var.alb_arn # If ALB is created using this module, then ALB arn value is directly assigned from newly created ALB, otherwise the arn value is passed using the variable.
}

resource "aws_lb_listener" "listener" {
  for_each = { for k, v in var.listeners : k => v if var.create_alb_listener }

  load_balancer_arn = local.alb_arn
  port              = try(each.value.port, 80)
  protocol          = try(each.value.protocol, "HTTP")
  ssl_policy        = try(each.value.ssl_policy, var.ssl_policy)
  certificate_arn   = try(each.value.certificate_arn, null)

  dynamic "default_action" {
    for_each = try([each.value.fixed_response], [])

    content {
      fixed_response {
        content_type = default_action.value.content_type
        message_body = try(default_action.value.message_body, null)
        status_code  = try(default_action.value.status_code, null)
      }

      order = try(default_action.value.order, null)
      type  = "fixed-response"
    }
  }

  dynamic "default_action" {
    for_each = try([each.value.forward], [])

    content {
      order            = try(default_action.value.order, null)
      target_group_arn = try(default_action.value.arn, aws_lb_target_group.target_group[default_action.value.target_group_key].arn, null)
      type             = "forward"
    }
  }

  tags = merge(
    try(each.value.tags, {}),
    var.tags
  )
}

#########################
#  LISTENER CERTIFICATE #
#########################

resource "aws_lb_listener_certificate" "listener_certificate" {
  count           = var.attach_certificate ? 1 : 0
  certificate_arn = var.certificate_arn
  listener_arn    = var.listener_arn
}

##################
#  TARGET GROUP  #
##################

## Target Group is needed for fixed-response action of listener
resource "aws_lb_target_group" "target_group" {
  for_each = { for k, v in var.target_groups : k => v if var.create_alb_listener }

  name        = try(each.value.name, null)
  name_prefix = try(each.value.name_prefix, null)
  port        = each.value.port
  protocol    = try(each.value.protocol, "HTTP")
  target_type = try(each.value.target_type, "instance")
  vpc_id      = try(each.value.vpc_id, var.vpc_id)

  dynamic "stickiness" {
    for_each = try([each.value.stickiness], [])

    content {
      type            = lookup(stickiness.value, "type", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      cookie_name     = lookup(stickiness.value, "cookie_name", null)
      enabled         = lookup(stickiness.value, "enabled", true)
    }
  }

  dynamic "health_check" {
    for_each = try([each.value.health_check], [])

    content {
      enabled             = lookup(health_check.value, "enabled", true)
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

  tags = merge(try(
    each.value.tags,
    {
      "Name" = each.value.name
    }),
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}