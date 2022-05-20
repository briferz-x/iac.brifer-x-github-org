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
  codeowners_file_line = "${var.path} ${join(" ", local.full_teams)}"
}

output "line" {
  value = local.codeowners_file_line
}
