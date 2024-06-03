##################
#  variables.tf  #
##################

variable "rules" {
  description = "Map of listener rules configurations to create"
  type        = any
  default     = {}
}

variable "target_groups" {
  description = "Map of target group configurations to create"
  type        = any
  default     = {}
}

variable "create_tg" {
  description = "Flag for Target Group Creation"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}