resource "google_service_account" "gke" {
  account_id   = "${var.app}-gke-sa"
  display_name = "${var.app} Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "gitea-cloudsql"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.app}-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "g1-small"

    service_account = google_service_account.gke.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

