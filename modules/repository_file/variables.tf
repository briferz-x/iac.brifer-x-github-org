variable "repository" {
  type        = any
  description = "The repository resource related to the repository file."
}

variable "branch" {
  type        = any
  description = "The branch resource related to the repository file."
}

variable "file_path" {
  type        = string
  description = "The full file path of the repository file."
}

variable "content" {
  type        = string
  description = "The content of the repository file."
}

variable "commit_author" {
  type        = string
  description = "The commit author's name of the repository file."
  default     = null
  nullable    = true
}

variable "commit_email" {
  type        = string
  description = "The commit description of the repository file."
  default     = null
  nullable    = true
}

variable "commit_message" {
  type        = string
  description = "The commit message of the repository file."
  default     = null
  nullable    = true
}

variable "overwrite_on_create" {
  type    = bool
  default = true
}
