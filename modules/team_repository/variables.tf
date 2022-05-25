variable "team_repository_conf" {
  type        = any
  description = "The configuration regarding a team repository resource."

  validation {
    condition     = lookup(var.team_repository_conf, "admin_team", false) || lookup(var.team_repository_conf, "permission", "pull") != "admin"
    error_message = "A non-admin team cannot have permission attribute set to \"admin\"."
  }
}

variable "team" {
  type        = any
  description = "The related team resource."
}

variable "repository" {
  type        = any
  description = "The related repository resource."
}
