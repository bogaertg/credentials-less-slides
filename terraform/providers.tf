provider "google" {
  project = var.project_id
}

provider "google" {
  alias = "org"
}

provider "github" {
}

data "google_client_config" "default" {
}

provider "kubernetes" {
  host = "https://${google_container_cluster.primary.endpoint}"

  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
  token = data.google_client_config.default.access_token
}
