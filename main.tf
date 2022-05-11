provider "github" {
  owner = var.github_owner
}

data "github_organization" "organization" {
  name = "briferz-x"
}

resource "github_repository" "this-repo" {
  name = "iac.brifer-x-github-org"
  visibility = "private"
}
