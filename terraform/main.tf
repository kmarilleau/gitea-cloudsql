resource "google_project_service" "services" {
  for_each = toset(var.services)
  project  = var.gcp_project
  service  = each.value

  disable_dependent_services = false
}

resource "google_sql_database_instance" "master" {
  name             = "${var.app}-db"
  database_version = "POSTGRES_${var.db_version}"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_service_account" "gsa" {
  account_id   = var.gsa_name
  display_name = "GSA Service Account"
}

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/${var.gsa_name}]",
  ]
}

# resource "kubernetes_service_account" "gsa" {
#   metadata {
#     name = var.gsa_name
#     annotations = {
#       "iam.gke.io/gcp-service-account" = "${var.gsa_name}@${var.gcp_project}.iam.gserviceaccount.com"
#     }
#   }
# }
