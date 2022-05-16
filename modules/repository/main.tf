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
