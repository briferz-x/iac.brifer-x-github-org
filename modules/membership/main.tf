locals {
  is_owner            = lookup(var.member_conf, "is_owner", false)
  membership_role     = local.is_owner? "admin" : "member"
  member_teams        = lookup(var.member_conf, "teams", [])
  member_team_mapping = {
  for team in local.member_teams : team["name"] => team
  }
}

resource "github_membership" "membership" {
  username = var.member_conf["username"]
  role     = local.membership_role
}

module "team_membership" {
  source = "../team_membership"

  for_each = local.member_team_mapping

  membership       = github_membership.membership
  team             = var.teams[each.key]
  team_member_conf = each.value
}
