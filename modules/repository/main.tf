locals {
  visibility = var.is_private? "private" : "public"
}

resource "github_repository" "repository" {
  name = var.name

  visibility           = local.visibility
  has_downloads        = var.has_downloads
  has_issues           = var.has_issues
  has_projects         = var.has_projects
  has_wiki             = var.has_wiki
  vulnerability_alerts = var.vulnerability_alerts
}
