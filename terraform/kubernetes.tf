resource "kubernetes_service_account" "gsa" {
  metadata {
    name = var.gsa_name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${var.gsa_name}@${var.gcp_project}.iam.gserviceaccount.com"
    }
  }
}
