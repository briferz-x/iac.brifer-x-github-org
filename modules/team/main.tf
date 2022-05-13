locals {
  is_secret        = lookup(var.team_conf, "is_secret", true)
  team_privacy     = local.is_secret? "secret" : "closed"
  parent_team_name = lookup(var.team_conf, "parent_team", "")
}

data "github_team" "parent_team" {
  count = local.parent_team_name == ""? 0 : 1

  slug = urlencode(local.parent_team_name)
}

resource "github_team" "team" {
  name           = var.team_conf["name"]
  description    = lookup(var.team_conf, "description", null)
  privacy        = local.team_privacy
  parent_team_id = local.parent_team_name == ""? null : data.github_team.parent_team[0].id
}
