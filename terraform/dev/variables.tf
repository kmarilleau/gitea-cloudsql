variable "app" {
  default = "gitea-cloudsql"
}

variable "gcp_project" {
  type = string
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}
