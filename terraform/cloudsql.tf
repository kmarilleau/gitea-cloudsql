resource "google_sql_database_instance" "master" {
  name             = "${var.app}-db"
  database_version = "POSTGRES_${var.db_version}"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "user" {
  depends_on = [
    google_sql_database_instance.master
  ]

  instance = google_sql_database_instance.master.name
  name     = var.cloudsql_user
  password = var.cloudsql_password
}
