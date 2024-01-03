################################
#  LOAD BALANCER VARIABLES #
################################

variable "create_alb" {
  description = "Create ALB"
  type        = bool
  default     = false
}

variable "create_alb_listener" {
  description = "Create ALB Listener"
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the LB"
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = true
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB"
  type        = list(string)
  default     = []
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  type        = number
  default     = 60
}

variable "access_logs" {
  description = "An Access Logs block"
  type = list(object({
    bucket  = string
    prefix  = string
    enabled = bool
  }))
  default = []
}

variable "security_groups" {
  description = "The list of security groups for ALB."
  type        = list(any)
  default     = []
}

################################
#  LISTENER VARIABLES #
################################

variable "alb_arn" {
  description = "ALB arn" # It is required if you have set the value of var.create_alb = false
  type        = string
  default     = ""
}

variable "port" {
  description = "The port on which the load balancer is listening"
  type        = string
  default     = "80"
}

variable "protocol" {
  description = "The protocol for connections from clients to the load balancer"
  type        = string
  default     = "HTTP"
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS"
  type        = string
  default     = ""
}

variable "listener_default_action_fixed_response" {
  description = "Default actions for the listener"
  type = list(object({
    content_type = string
    message_body = string
    status_code  = number
  }))
  default = [{
    content_type = "text/plain"
    message_body = "Bad request"
    status_code  = 400
  }]
}

#####################################
#  LISTENER CERTIFICATE VARIABLES #
#####################################

variable "attach_certificate" {
  description = "Indicate whether a new certificate needs to be attached"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "The ARN of the certificate to attach to the listener"
  type        = string
  default     = ""
}

variable "listener_arn" {
  description = "The ARN of the listener to which to attach the rule"
  type        = string
  default     = ""
}

#####################################
#  TARGET GROUP VARIABLES #
#####################################

variable "target_group_name" {
  description = "Target group name"
  type        = string
  default     = ""
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group"
  type        = string
  default     = "instance"
}

variable "stickiness" {
  description = " A Stickiness block"
  type = list(object({
    type            = string
    cookie_duration = number
  }))
  default = [{
    type            = "lb_cookie"
    cookie_duration = 86400
  }]
}

variable "health_check" {
  description = "Listener Rule Health Check"
  type        = map(string)
  default     = {}
}