variable "name" {
  type        = string
  description = "The repository name"
}

variable "is_private" {
  type        = bool
  description = "Whether the repository is private or public"
  default     = true
}

variable "has_downloads" {
  type    = bool
  default = true
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_projects" {
  type    = bool
  default = true
}

variable "has_wiki" {
  type    = bool
  default = true
}

variable "vulnerability_alerts" {
  type    = bool
  default = true
}
