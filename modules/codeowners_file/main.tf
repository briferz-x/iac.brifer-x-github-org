locals {
  # only teams with push, maintain and admin permission on the repository can be part of the CODEOWNERS file
  # source: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners#codeowners-syntax
  code_owners_team_permission_filter_list    = ["push", "maintain", "admin"]
  code_owners_team_permission_filter_mapping = {
  for code_owners_team_permission_filter in local.code_owners_team_permission_filter_list : code_owners_team_permission_filter => true
  }
}

module "codeowners_file_line" {
  source = "../codeowners_file_line"

  count = length(var.code_owners)

  organization_name = var.organization_name
  path              = var.code_owners[count.index].path
  teams             = [
  for team_obj in var.code_owners[count.index] : team_obj.team.slug
  if lookup(local.code_owners_team_permission_filter_mapping, team_obj.team_repository.permission, false)
  ]
}

module "repository_file" {
  source = "../repository_file"

  repository = var.repository
  branch     = var.branch

  content   = join("", [for codeowners_file_line in module.codeowners_file_line : codeowners_file_line.line])
  file_path = "CODEOWNERS"

  commit_message = "Add CODEOWNERS file managed by Terraform."
}
