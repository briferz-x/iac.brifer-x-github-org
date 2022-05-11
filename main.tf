provider "github" {
  owner = var.github_owner
}

data "github_organization" "organization" {
  name = var.github_owner
}

resource "github_repository" "this-repo" {
  name = "iac.brifer-x-github-org"

  visibility           = "private"
  has_downloads        = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  vulnerability_alerts = true
}

resource "github_branch" "this-repo-main-branch" {
  branch     = "main"
  repository = github_repository.this-repo.id
}

resource "github_branch_default" "this-repo-branch-default" {
  repository = github_repository.this-repo.id
  branch     = github_branch.this-repo-main-branch.branch
}
