resource "github_repository_file" "repository_file" {
  repository = var.repository.name
  branch     = var.branch.branch
  file       = var.file_path
  content    = var.content

  commit_author       = var.commit_author
  commit_email        = var.commit_email
  commit_message      = var.commit_message
  overwrite_on_create = var.overwrite_on_create
}
