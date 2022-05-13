variable "member_conf" {
  type        = any
  description = "The configuration regarding a member resource."
}

variable "teams" {
  type        = map(any)
  description = "The teams of the organization"
  default = {}
}
