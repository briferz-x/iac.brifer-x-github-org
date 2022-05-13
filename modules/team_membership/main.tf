locals {
  is_maintainer        = lookup(var.team_member_conf, "is_maintainer", false)
  team_membership_role = local.is_maintainer? "maintainer" : "member"
}

resource "github_team_membership" "team_membership" {
  team_id  = var.team.id
  username = var.membership.username
  role     = local.team_membership_role
}
