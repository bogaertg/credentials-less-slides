resource "google_project_service" "iam" {
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "gar" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "time_sleep" "gar_sleeper" {
  create_duration = "30s"
  depends_on      = [google_project_service.gar]
}

resource "google_project_service" "sql" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

