####################
# listener_rule.tf #
####################

###################################################
# Listener Rule(s)
###################################################

resource "aws_lb_listener_rule" "this" {
  for_each = var.rules

  listener_arn = each.value.listener_arn
  priority     = try(each.value.priority, null)


  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "fixed-response"]

    content {
      type  = "fixed-response"
      order = try(action.value.order, null)

      fixed_response {
        content_type = action.value.content_type
        message_body = try(action.value.message_body, null)
        status_code  = try(action.value.status_code, null)
      }
    }
  }

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "redirect"]

    content {
      type  = "redirect"
      order = try(action.value.order, null)

      redirect {
        host        = try(action.value.host, null)
        path        = try(action.value.path, null)
        port        = try(action.value.port, null)
        protocol    = try(action.value.protocol, null)
        query       = try(action.value.query, null)
        status_code = action.value.status_code
      }
    }
  }

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "forward"]

    content {
      type             = "forward"
      order            = try(action.value.order, null)
      target_group_arn = try(action.value.target_group_arn, aws_lb_target_group.this[action.value.target_group_key].arn) #
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "host_header")]

    content {
      dynamic "host_header" {
        for_each = try([condition.value.host_header], [])

        content {
          values = host_header.value.values
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "other_header")]
    content {

      dynamic "http_header" {
        for_each = try([condition.value.other_header], [])

        content {
          http_header_name = other_header.http_header_name
          values           = other_header.values
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "path_pattern")]

    content {
      dynamic "path_pattern" {
        for_each = try([condition.value.path_pattern], [])

        content {
          values = path_pattern.value.values
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "source_ip")]

    content {
      dynamic "source_ip" {
        for_each = try([condition.value.source_ip], [])

        content {
          values = source_ip.value.values
        }
      }
    }
  }

  tags = merge(
    try(each.value.tags, {}),
    var.tags
  )
}

resource "random_string" "random" {
  for_each = { for k, v in var.target_groups : k => v if var.create_tg }

  length  = 2
  special = false
  upper   = false
  keepers = {
    name        = try(each.value.name, null)
    protocol    = try(each.value.protocol, null)
    port        = try(each.value.port, null)
    target_type = try(each.value.target_type, null)
  }
}

###################################################
# Target Group(s)
###################################################

resource "aws_lb_target_group" "this" {
  for_each = { for k, v in var.target_groups : k => v if var.create_tg }

  name        = try("${each.value.name}-${random_string.random[each.key].result}", null)
  name_prefix = try(each.value.name_prefix, null)
  port        = each.value.port
  protocol    = try(each.value.protocol, "HTTP")
  target_type = try(each.value.target_type, "ip")
  vpc_id      = each.value.vpc_id

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
