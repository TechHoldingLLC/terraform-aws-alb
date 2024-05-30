# ALB
Below are the examples of calling this module.

## Create an ALB
### If you want to create ALB only, pass below inputs according to your requirements
```
module "alb" {
  source                     = "./alb"
  create_alb                 = true
  name                       = "my-alb"
  subnets                    = module.alb_private_subnet.private_subnet_ids
  internal                   = true  # Give false value if you want to make it public.
  security_groups            = [module.sg.id]
  enable_deletion_protection = true
  providers = {
    aws = aws
  }
}
```

## Create an ALB Listener and Target Group
### If you want to create ALB Listener of HTTP protocol and Target Group only, pass below inputs according to your requirements
```
module "alb_listener" {
  source              = "./alb"
  create_alb_listener = true
  alb_arn             = module.alb.arn
  vpc_id              = module.vpc.id
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "ex-instance"
      }
    }
  }
  target_groups = {
    ex-instance = {
      name        = "my-alb-listener-http"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      target_id   = "i-instance-id"

      stickiness = {
        type            = "lb_cookie"
        cookie_duration = 3600
      }
      health_check = {
        interval            = 30
        path                = "/"
        timeout             = 15
        healthy_threshold   = 2
        unhealthy_threshold = 2
        port                = 443
        protocol            = "HTTPS" # Other value is HTTPS
        enabled             = true
      }
    }
  }
  
  providers = {
    aws = aws
  }
}
```

### If you want to create ALB Listener of HTTPS protocol and Target Group only, pass below inputs according to your requirements
```
module "acm" {
  source          = "./acm"
  domain_name     = "example.com"
  route53_zone_id = "Zone id"
}

module "alb_listener_https" {
  source              = "./alb"
  create_alb_listener = true
  alb_arn             = module.alb.arn
  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.arn
      forward = {
        target_group_key = "ex-instance" #or we can pass arn of target group, ie. arn=var.tg_arn
      }
    }
  }
  target_groups = {
    ex-instance = {
      name        = "my-alb-listener-https"
      protocol    = "HTTPS"
      port        = 443
      target_type = "instance"
      target_id   = "i-instance-id"

      stickiness = {
        type            = "lb_cookie"
        cookie_duration = 3600
      }
      health_check = {
        interval            = 30
        path                = "/"
        timeout             = 15
        healthy_threshold   = 2
        unhealthy_threshold = 2
        port                = 443
        protocol            = "HTTPS"
        enabled             = true
      }
    }
  }
  vpc_id              = module.vpc.id
  providers = {
    aws = aws
  }
}
```

### If you want to create ALB with its Listener and Target Group, pass below inputs according to your requirements
```
# ALB
module "alb" {
  source                     = "./alb"
  create_alb                 = true
  name                       = "my-alb"
  subnets                    = module.alb_private_subnet.private_subnet_ids
  internal                   = true  # Give false value if you want to make it public.
  security_groups            = [module.sg.id]
  enable_deletion_protection = true
  vpc_id                     = module.vpc.id

# ALB Listener and Target Group
  create_alb_listener = true

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Bad request"
        status_code  = 400
      }
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.arn
      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  target_groups = {
    ex-instance = {
      name        = "my-alb-listener-https"
      protocol    = "HTTPS"
      port        = 443
      target_type = "instance"
      target_id   = "i-instance-id"

      stickiness = {
        type            = "lb_cookie"
        cookie_duration = 3600
      }
      health_check = {
        interval            = 30
        path                = "/"
        timeout             = 15
        healthy_threshold   = 2
        unhealthy_threshold = 2
        port                = 443
        protocol            = "HTTPS"
        enabled             = true
      }
    }
  }
  stickiness = [{
    type            = "lb_cookie"
    cookie_duration = 3600
  }]
  health_check = {
    interval            = 30
    path                = "/"
    timeout             = 15
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = 80
    protocol            = "HTTP" # Other value is HTTPS
    enabled             = true
  }
  providers = {
    aws = aws
  }
}
```