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

variable "services" {
  type    = list(string)
  default = [
    "sqladmin.googleapis.com"
    ]
}

variable "db_version" {
  default = "13"
}
