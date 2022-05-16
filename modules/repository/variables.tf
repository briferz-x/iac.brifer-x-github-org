variable "repo_conf" {
  type = any
}

variable "teams" {
  type        = map(any)
  description = "The teams of the organization"
  default     = {}
}

variable "admin_teams" {
  type        = map(any)
  description = "The administrator teams of the organization"
  default     = {}
}
