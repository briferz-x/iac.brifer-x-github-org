terraform {
  required_version = ">= 1.1.9"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.24"
    }
  }
}
