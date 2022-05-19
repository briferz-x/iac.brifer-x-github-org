variable "repository" {
  type = any
}

variable "branch" {
  type = any
}

variable "file_path" {
  type = string
}

variable "content" {
  type = string
}

variable "commit_author" {
  type     = string
  default  = null
  nullable = true
}

variable "commit_email" {
  type     = string
  default  = null
  nullable = true
}

variable "commit_message" {
  type     = string
  default  = null
  nullable = true
}

variable "overwrite_on_create" {
  type    = bool
  default = true
}
