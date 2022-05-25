variable "organization_name" {
  type = string
}

variable "path" {
  type = string
}

variable "teams" {
  type = list(string)
}

locals {
  full_teams           = [for team in var.teams : "@${var.organization_name}/${team}"]
  codeowners_file_line = length(var.teams) > 0? "${var.path} ${join(" ", local.full_teams)}\n" : ""
}

output "line" {
  value = local.codeowners_file_line
}
