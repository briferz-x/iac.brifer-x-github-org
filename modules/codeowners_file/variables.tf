variable "repository" {
  type = any
}

variable "branch" {
  type = any
}

variable "organization_name" {
  type = string
}

variable "code_owners" {
  type = list(object({
    path  = string
    teams = list(string)
  }))
}