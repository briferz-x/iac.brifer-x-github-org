locals {
  required_status_checks        = lookup(var.branch_protection_conf, "required_status_checks", {})
  required_pull_request_reviews = lookup(var.branch_protection_conf, "required_pull_request_reviews", {})
}

resource "github_branch_protection" "branch_protection" {
  pattern       = var.branch_protection_conf["pattern"]
  repository_id = var.repository.name

  enforce_admins                  = lookup(var.branch_protection_conf, "enforce_admins", false)
  required_linear_history         = lookup(var.branch_protection_conf, "required_linear_history", false)
  require_signed_commits          = lookup(var.branch_protection_conf, "require_signed_commits", false)
  require_conversation_resolution = lookup(var.branch_protection_conf, "require_conversation_resolution", false)

  required_status_checks {
    strict   = lookup(local.required_status_checks, "strict", false)
    contexts = lookup(local.required_status_checks, "contexts", [])
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = lookup(local.required_pull_request_reviews, "dismiss_stale_reviews", true)
    restrict_dismissals             = lookup(local.required_pull_request_reviews, "restrict_dismissals", true)
    require_code_owner_reviews      = lookup(local.required_pull_request_reviews, "require_code_owner_reviews", true)
    required_approving_review_count = lookup(local.required_pull_request_reviews, "required_approving_review_count", 1)
  }

  allows_deletions    = lookup(var.branch_protection_conf, "allows_deletions", false)
  allows_force_pushes = lookup(var.branch_protection_conf, "allows_force_pushes", false)
}
