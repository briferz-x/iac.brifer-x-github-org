resource "github_branch" "branch" {
  branch        = var.branch_conf["name"]
  repository    = var.repository.name
  source_branch = lookup(var.branch_conf, "source_branch", null)
}

locals {
  is_default = lookup(var.branch_conf, "default", false)
}

resource "github_branch_default" "default_branch" {
  count      = local.is_default? 1 : 0
  branch     = github_branch.branch.branch
  repository = github_branch.branch.repository
}
