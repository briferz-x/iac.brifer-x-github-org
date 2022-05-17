locals {
  admin_team_name = "devops"
  admin_team_conf = {
    name        = local.admin_team_name
    description = "The DevOps team."
    is_secret   = false
  }
}

module "admin_team" {
  source    = "./modules/team"
  team_conf = local.admin_team_conf
}

locals {
  admin_team_resource_mapping = { (local.admin_team_name) = module.admin_team.team }

  admin_conf_folder      = "admin_conf"
  admin_conf_folder_path = "${path.module}/${local.admin_conf_folder}"

  admin_members_file_path = "${local.admin_conf_folder_path}/admin_members.yaml"
  admin_members_file      = file(local.admin_members_file_path)
  admin_members           = yamldecode(local.admin_members_file)
  admin_member_mapping    = {
  for member in local.admin_members : member["username"] => member
  }
}

module "admin_membership" {
  source = "./modules/membership"

  for_each = local.admin_member_mapping

  member_conf = merge(each.value, { admin_member = true })
  teams       = local.admin_team_resource_mapping
}
