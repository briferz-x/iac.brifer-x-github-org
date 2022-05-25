variable "repository" {
  type = any
}

variable "branch" {
  type = any
}

variable "organization_name" {
  type = string
}

variable "code_owners" {
  type = list(object({
    path  = string
    teams = list(object({
      team            = any
      team_repository = any
    }))
  }))
  description = "List of objects containing a path and a list of objects containing a team and a team repository resources."
}