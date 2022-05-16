locals {
  visibility = lookup(var.repo_conf, "is_private", true)? "private" : "public"
}

resource "github_repository" "repository" {
  name = var.repo_conf["name"]

  visibility             = local.visibility
  delete_branch_on_merge = lookup(var.repo_conf, "delete_branch_on_merge", true)
  allow_squash_merge     = lookup(var.repo_conf, "allow_squash_merge", true)
  allow_merge_commit     = lookup(var.repo_conf, "allow_merge_commit", true)
  allow_rebase_merge     = lookup(var.repo_conf, "allow_rebase_merge", true)
  has_downloads          = lookup(var.repo_conf, "has_downloads", true)
  has_issues             = lookup(var.repo_conf, "has_issues", true)
  has_projects           = lookup(var.repo_conf, "has_projects", true)
  has_wiki               = lookup(var.repo_conf, "has_wiki", true)
  is_template            = lookup(var.repo_conf, "is_template", false)
  vulnerability_alerts   = lookup(var.repo_conf, "vulnerability_alerts", true)
}

locals {
  branches     = lookup(var.repo_conf, "branches", [])
  branches_map = {
  for branch in local.branches : branch["name"] => branch
  }
}

module "branch" {
  source = "../branch"

  for_each = local.branches_map

  branch_conf = each.value
  repository  = github_repository.repository
}

module "admin_team_repository" {
  source = "../team_repository"

  for_each = var.admin_teams

  repository           = github_repository.repository
  team                 = each.value
  team_repository_conf = { "permission" = "admin" }
}

locals {
  teams        = lookup(var.repo_conf, "teams", [])
  team_mapping = {
  for team in local.teams : team["name"] => team
  }
}

module "team_repository" {
  source = "../team_repository"

  for_each = local.team_mapping

  repository           = github_repository.repository
  team                 = var.teams[each.key]
  team_repository_conf = each.value
}
