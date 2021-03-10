provider "google" {
  project = var.gcp_project
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = var.app
  location = var.region
}

provider "kubernetes" {
  load_config_file = false

  host  = "https://${data.google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.master_auth[0].cluster_ca_certificate,
  )
}