provider "github" {
  owner = var.github_owner
}

resource "github_repository" "this_repo" {
  name = "iac.brifer-x-github-org"

  visibility           = "private"
  has_downloads        = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  vulnerability_alerts = true
}

resource "github_branch" "this_repo_main_branch" {
  branch     = "main"
  repository = github_repository.this_repo.id
}

resource "github_branch_default" "this_repo_branch_default" {
  repository = github_repository.this_repo.id
  branch     = github_branch.this_repo_main_branch.branch
}

locals {
  conf_folder       = "conf"
  conf_folder_path  = "${path.module}/${local.conf_folder}"
  teams_file_path   = "${local.conf_folder_path}/teams.yaml"
  teams_file        = file(local.teams_file_path)
  teams             = yamldecode(local.teams_file)
  team_conf_mapping = {
  for team in local.teams : team["name"] => team
  }
}

module "team" {
  source = "./modules/team"

  for_each = local.team_conf_mapping

  team_conf = each.value
}

locals {
  members_file_path = "${local.conf_folder_path}/members.yaml"
  members_file      = file(local.members_file_path)
  members           = yamldecode(local.members_file)
  member_mapping    = {
  for member in local.members : member["username"] => member
  }
  team_resource_mapping = {
  for team_name, team_module in module.team : team_name => team_module.team
  }
}

module "membership" {
  source = "./modules/membership"

  for_each = local.member_mapping

  member_conf = merge(each.value, { admin_member = false })
  teams       = local.team_resource_mapping
}

locals {
  repositories = {
  for path in fileset(path.module, "${local.conf_folder}/repositories/*.yaml") : basename(path) => file(path)
  }
  repository_mapping = {
  for file_name, file_content in local.repositories : trimsuffix(file_name, ".yaml") => yamldecode(file_content)
  }
}

module "repository" {
  source = "./modules/repository"

  for_each = local.repository_mapping

  repo_conf   = each.value
  teams       = local.team_resource_mapping
  admin_teams = local.admin_team_resource_mapping
}
