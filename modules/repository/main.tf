locals {
  visibility = lookup(var.repo_conf, "is_private", true)? "private" : "public"
}

resource "github_repository" "repository" {
  name = var.repo_conf["name"]

  auto_init              = true
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
  branches   = lookup(var.repo_conf, "branches", [])
  branch_map = {
  for branch in local.branches : branch["name"] => branch
  }
}

module "branch" {
  source = "../branch"

  for_each = local.branch_map

  branch_conf = each.value
  repository  = github_repository.repository
}

module "admin_team_repository" {
  source = "../team_repository"

  for_each = var.admin_teams

  repository           = github_repository.repository
  team                 = each.value
  team_repository_conf = { admin_team = true, permission = "admin" }
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
  team_repository_conf = merge(each.value, { admin_team = false })
}

locals {
  code_owners_admin_teams_list = [
  for _, admin_team_repository_module in module.admin_team_repository : {
    team            = admin_team_repository_module.team,
    team_repository = admin_team_repository_module.team_repository
  }
  ]
  admin_code_owners = [
  for admin_codeowners_path in var.admin_codeowners_paths : {
    path = admin_codeowners_path, teams = local.code_owners_admin_teams_list
  }
  ]

  code_owners_default_team_list = [
  for _, team_repository_module in module.team_repository : {
    team            = team_repository_module.team,
    team_repository = team_repository_module.team_repository
  }
  ]
  code_owners_default_paths = [
    "*"
  ]
  conf_code_owners = lookup(var.repo_conf, "code_owners", [])

  code_owners = length(local.conf_code_owners) == 0 ? [
  for codeowners_path in local.code_owners_default_paths : {
    path = codeowners_path, teams = local.code_owners_default_team_list
  }
  ] : [
  for conf_code_owner in local.conf_code_owners : {
    path  = conf_code_owner["path"],
    teams = [
    for team in conf_code_owner["teams"] : {
      team            = module.team_repository[team].team,
      team_repository = module.team_repository[team].team_repository
    }
    ]
  }
  ]
}

module "codeowners_file" {
  source = "../codeowners_file"

  for_each = {for branch_key, branch_module in module.branch : branch_key => branch_module if branch_module.include_code_owners_file}

  branch            = each.value.branch
  # Admin code owners go last because the latest lines take precedence.
  code_owners       = concat(local.code_owners, local.admin_code_owners)
  organization_name = var.organization_name
  repository        = github_repository.repository
}

locals {
  branch_protections    = lookup(var.repo_conf, "branch_protections", [])
  branch_protection_map = {
  for branch_protection in local.branch_protections : branch_protection["pattern"] => branch_protection
  }
}

module "branch_protection" {
  source = "../branch_protection"

  for_each = local.branch_protection_map

  branch_protection_conf = each.value
  repository             = github_repository.repository
}
