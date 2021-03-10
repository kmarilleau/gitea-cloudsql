provider "google" {
  project = var.gcp_project
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
  username = google_container_cluster.primary.master_auth[0].username
  password = google_container_cluster.primary.master_auth[0].password
  host     = google_container_cluster.primary.endpoint

  client_certificate     = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}