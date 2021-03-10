resource "google_project_service" "services" {
  for_each = toset(var.services)
  project  = var.gcp_project
  service  = each.value

  disable_dependent_services = false
}

resource "google_service_account" "gsa" {
  account_id   = var.gsa_name
  display_name = "GSA Service Account"
}

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/${var.ksa_name}]",
  ]
}
