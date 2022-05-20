module "codeowners_file_line" {
  source = "../codeowners_file_line"

  count = length(var.code_owners)

  organization_name = var.organization_name
  path              = var.code_owners[count.index].path
  teams             = var.code_owners[count.index].teams
}

locals {
  codeowners_file_lines = [for codeowners_file_line in module.codeowners_file_line : codeowners_file_line.line]
}

module "repository_file" {
  source = "../repository_file"

  repository = var.repository
  branch     = var.branch

  content   = "${join("\n", local.codeowners_file_lines)}\n"
  file_path = "CODEOWNERS"
}
