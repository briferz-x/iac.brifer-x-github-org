module "repository_file" {
  source = "../repository_file"

  branch     = var.branch
  content    = join("\n", [for code_owner in var.code_owners : "${code_owner.path} ${join(" ", [for team in code_owner.teams: "@${var.organization_name}/${team}"])}"])
  file_path  = "CODEOWNERS"
  repository = var.repository
}