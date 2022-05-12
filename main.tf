provider "github" {
  owner = var.github_owner
}

data "github_organization" "organization" {
  name = var.github_owner
}

resource "github_team" "devops_team" {
  name        = "devops"
  description = "The DevOps team."
  privacy     = "closed"
}

resource "github_team_membership" "briferz_devops_membership" {
  team_id  = github_team.devops_team.id
  username = "briferz"
  role     = "maintainer"
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
  conf_folder  = "conf"
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

  repo_conf = each.value
}
