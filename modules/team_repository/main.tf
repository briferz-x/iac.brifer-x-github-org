resource "github_team_repository" "team_repository" {
  repository = var.repository.name
  team_id    = var.team.id
  permission = lookup(var.team_repository_conf, "permission", "pull")
}
