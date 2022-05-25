variable "member_conf" {
  type        = any
  description = "The configuration regarding a member resource."
  validation {
    condition     = lookup(var.member_conf, "admin_member", false) || !lookup(var.member_conf, "is_owner", false)
    error_message = "A non-admin member cannot have is_owner attribute set to true."
  }
}

variable "teams" {
  type        = map(any)
  description = "The teams of the organization."
  default     = {}
}
