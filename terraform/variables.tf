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
  type = list(string)
  default = [
    "sqladmin.googleapis.com"
  ]
}

variable "db_version" {
  default = "13"
}

variable "gsa_name" {
  default = "gitea-gsa"
}

variable "ksa_name" {
  default = "gitea-ksa"
}

variable "cloudsql_user" {
  type = string
}

variable "cloudsql_password" {
  type = string
}
