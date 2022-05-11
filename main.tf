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
