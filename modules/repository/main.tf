locals {
  visibility = lookup(var.repo_conf, "is_private", true)? "private" : "public"
}

resource "github_repository" "repository" {
  name = var.repo_conf["name"]

  visibility           = local.visibility
  has_downloads        = lookup(var.repo_conf, "has_downloads", true)
  has_issues           = lookup(var.repo_conf, "has_issues", true)
  has_projects         = lookup(var.repo_conf, "has_projects", true)
  has_wiki             = lookup(var.repo_conf, "has_wiki", true)
  vulnerability_alerts = lookup(var.repo_conf, "vulnerability_alerts", true)
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
