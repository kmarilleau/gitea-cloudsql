resource "kubernetes_service_account" "ksa" {
  depends_on = [
    google_container_cluster.primary
  ]

  metadata {
    name = var.ksa_name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${var.gsa_name}@${var.gcp_project}.iam.gserviceaccount.com"
    }
  }
}

resource "kubernetes_deployment" "gitea" {
  depends_on = [
    google_container_cluster.primary
  ]

  metadata {
    name = "gitea"
  }

  spec {
    selector {
      match_labels = {
        app = "gitea"
      }
    }

    template {
      metadata {
        labels = {
          app = "gitea"
        }
      }

      spec {
        container {
          name  = "gitea"
          image = "gitea/gitea:1.13.4"

          port {
            container_port = 3000
          }

          env {
            name  = "INSTALL_LOCK"
            value = "true"
          }
          env {
            name  = "DB_TYPE"
            value = "postgres"
          }
          env {
            name  = "DB_HOST"
            value = "localhost:5432"
          }
          env {
            name  = "DB_NAME"
            value = var.db_name
          }
          env {
            name  = "DB_USER"
            value = var.cloudsql_user
          }
          env {
            name  = "DB_PASSWD"
            value = var.cloudsql_password
          }
        }

        container {
          name  = "cloudsql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.20.2"
          command = [
            "/cloud_sql_proxy",
            "-instances=${var.gcp_project}:${var.region}:${google_sql_database_instance.master.name}=tcp:5432"
          ]

          security_context {
            run_as_non_root = true
          }
        }

        restart_policy       = "Always"
        service_account_name = var.ksa_name
      }
    }
  }
}

resource "kubernetes_service" "gitea_service" {
  depends_on = [
    kubernetes_deployment.gitea
  ]

  metadata {
    name = "gitea-service"
  }

  spec {
    port {
      port        = 80
      target_port = 3000
    }

    selector = {
      app = "gitea"
    }

    type = "LoadBalancer"
  }
}
