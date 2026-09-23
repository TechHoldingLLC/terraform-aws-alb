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
  default     = false
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

variable "enable_cloudwatch_logs" {
  description = "Deliver ALB logs to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "cloudwatch_log_types" {
  description = "ALB log types to deliver. Valid values: ALB_ACCESS_LOGS, ALB_CONNECTION_LOGS, ALB_HEALTH_CHECK_LOGS"
  type        = list(string)
  default     = ["ALB_ACCESS_LOGS"]
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for ALB logs. Defaults to /aws/alb/<name>"
  type        = string
  default     = null
}

variable "cloudwatch_log_retention_in_days" {
  description = "Retention in days for the ALB CloudWatch log group"
  type        = number
  default     = 30
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

variable "listeners" {
  description = "Map of listener configurations to create"
  type        = any
  default     = {}
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

variable "target_groups" {
  description = "Map of target group configurations to create"
  type        = any
  default     = {}
}