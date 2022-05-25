variable "repo_conf" {
  type = any
}

variable "teams" {
  type        = map(any)
  description = "All the teams of the organization."
  default     = {}
}

variable "admin_teams" {
  type        = map(any)
  description = "The administrator teams of the organization."
  default     = {}
}

variable "admin_codeowners_paths" {
  type        = list(string)
  description = "The CODEOWNERS paths belonging to administrator teams."
  default     = []
}

variable "organization_name" {
  type        = string
  description = "The organization name."
}
