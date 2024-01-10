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
  target_group_name   = "my-alb-listener-http"
  port                = 80
  vpc_id              = module.vpc.id
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
  target_group_name   = "my-alb-listener-https"
  port                = 443
  protocol            = "HTTPS"
  vpc_id              = module.vpc.id
  certificate_arn     = module.acm.arn
  health_check = {
    interval            = 30
    path                = "/"
    timeout             = 15
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = 80
    protocol            = "HTTP"
    enabled             = true
  }
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

# ALB Listener and Target Group
  create_alb_listener = true
  alb_arn             = module.alb.arn
  target_group_name   = "my-alb-listener"
  port                = 80
  vpc_id              = module.vpc.id
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