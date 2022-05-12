locals {
  is_owner = lookup(var.member_conf, "is_owner", false)
  membership_role = local.is_owner? "admin": "member"
}

resource "github_membership" "membership" {
  username = var.member_conf["username"]
  role = local.membership_role
}
