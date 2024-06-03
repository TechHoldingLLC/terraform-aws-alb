# ALB Listener Rules
Below are the examples of calling this module.

## Create an ALB Listener Rules and Target group
### If you want to create ALB Listener Rules only, pass below inputs according to your requirements
```
module "alb_listener_rules" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-alb.git//listener_rule?ref=v1.0.4"

  rules = {
    http-redirect = {
      listener_arn = local.alb_http_listener_arn
      actions = [
        {
          type        = "redirect"
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      ]

      conditions = [{
        path_pattern = {
          values = ["/example1", "/example2"]
        }
      }]
    }
  }
}
```

### If you want to create ALB Listner Rules and Target Group, pass below inputs according to your requirements
```
module "alb_listener_rules" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-alb.git//listener_rule?ref=v1.0.4"

  rules = {
    https-forward = {
      listener_arn = local.alb_https_listener_arn
      actions = [
        {
          type             = "forward"
          target_group_key = "ex-ecs" #Or you can pass `target_group_arn`
        }
      ]

      conditions = [{
        host_header = {
          values = [local.domain]
        }
      }]
    }

    http-redirect = {
      listener_arn = local.alb_http_listener_arn
      actions = [
        {
          type        = "redirect"
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      ]

      conditions = [{
        host_header = {
          values = [local.domain]
        }
      }]
    }
  }

  create_tg = true
  target_groups = {
    ex-ecs = {
      name        = local.resource_name
      protocol    = "HTTP"
      port        = 80
      target_type = "ip"
      vpc_id      = local.vpc_id

      health_check = {
        interval            = 30
        path                = "/"
        timeout             = 15
        healthy_threshold   = 2
        unhealthy_threshold = 2
        protocol            = "HTTP" # Other value is HTTPS
        enabled             = true
      }
    }
  }

  providers = {
    aws = aws
  }
}