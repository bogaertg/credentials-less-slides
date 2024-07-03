resource "google_container_cluster" "primary" {
  name               = "demo2"
  location           = "europe-west4"
  initial_node_count = 1


  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
  node_config {
    service_account = google_service_account.sa_gke_nodes.email
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  deletion_protection = false

}

resource "google_service_account" "sa_gke_nodes" {
  account_id = "sa-gke-nodes"
}

resource "google_project_iam_member" "sa_gke_nodes_monitoring_viewer" {
  member  = "serviceAccount:${google_service_account.sa_gke_nodes.email}"
  project = var.project_id
  role    = "roles/monitoring.viewer"
}

resource "google_project_iam_member" "sa_gke_nodes_monitoring_metrics_writer" {
  member  = "serviceAccount:${google_service_account.sa_gke_nodes.email}"
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "sa_gke_nodes_logging_writer" {
  member  = "serviceAccount:${google_service_account.sa_gke_nodes.email}"
  project = var.project_id
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "sa_gke_nodes_stackdriver_writer" {
  member  = "serviceAccount:${google_service_account.sa_gke_nodes.email}"
  project = var.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
}

resource "google_project_iam_member" "sa_gke_nodes_autoscaling_metrics_writer" {
  member  = "serviceAccount:${google_service_account.sa_gke_nodes.email}"
  project = var.project_id
  role    = "roles/autoscaling.metricsWriter"
}

resource "google_project_iam_member" "sa_gke_nodes_artifact_registry_reader" {
  member  = "serviceAccount:${google_service_account.sa_gke_nodes.email}"
  project = var.project_id
  role    = "roles/artifactregistry.reader"
}

#resource "kubernetes_deployment_v1" "spring_cloud_gcp_storage" {
#  metadata {
#    name = "spring-cloud-gcp-storage"
#  }
#
#  spec {
#    replicas = 1
#    selector {
#      match_labels = {
#        test = "spring-cloud-gcp-storage"
#      }
#    }
#
#    template {
#      metadata {
#        labels = {
#          test = "spring-cloud-gcp-storage"
#        }
#      }
#      spec {
#        container {
#          image = "europe-west4-docker.pkg.dev/${data.google_project.project.project_id}/${google_artifact_registry_repository.repo.name}/my-app:latest"
#          name  = "spring-cloud-gcp-storage"
#          resources {
#            limits = {
#              cpu    = "500m"
#              memory = "1Gi"
#            }
#            requests = {
#              cpu    = "250m"
#              memory = "512Mi"
#            }
#          }
#          env {
#            name  = "GCS_BUCKET"
#            value = google_storage_bucket.demo2_bucket.name
#          }
#          liveness_probe {
#            http_get {
#              path = "/actuator/health/liveness"
#              port = 8080
#            }
#            initial_delay_seconds = 10
#            period_seconds        = 10
#          }
#          readiness_probe {
#            http_get {
#              path = "/actuator/health/readiness"
#              port = 8080
#            }
#            initial_delay_seconds = 10
#            period_seconds        = 10
#          }
#          startup_probe {
#            http_get {
#              path = "/actuator/health/liveness"
#              port = 8080
#            }
#            initial_delay_seconds = 30
#            period_seconds = 10
#          }
#        }
#      }
#    }
#  }
#
#  timeouts {
#    create = "3m"
#    update = "3m"
#    delete = "3m"
#  }
#
#  depends_on = [github_repository_file.foo]
#
#}
#
#resource "google_service_account" "sa_bucket" {
#  account_id = "sa-bucket"
#}
#
#resource "kubernetes_service_account_v1" "sa_workload_identity" {
#  metadata {
#    name = "sa-workload-identity"
#    annotations = {
#      "iam.gke.io/gcp-service-account" : google_service_account.sa_bucket.email
#    }
#  }
#}
#
#resource "google_service_account_iam_binding" "sa_bucket_workload_identity_binding" {
#  service_account_id = google_service_account.sa_bucket.name
#  role               = "roles/iam.workloadIdentityUser"
#
#  members = [
#    "serviceAccount:${var.project_id}.svc.id.goog[${kubernetes_service_account_v1.sa_workload_identity.metadata[0].namespace}/${kubernetes_service_account_v1.sa_workload_identity.metadata[0].name}]"
#  ]
#}
#
#resource "kubernetes_deployment_v1" "spring_cloud_gcp_storage_workload_identity" {
#  metadata {
#    name = "spring-cloud-gcp-storage-workload-identity"
#  }
#
#  spec {
#    replicas = 1
#    selector {
#      match_labels = {
#        test = "spring-cloud-gcp-storage-workload-identity"
#      }
#    }
#
#    template {
#      metadata {
#        labels = {
#          test = "spring-cloud-gcp-storage-workload-identity"
#        }
#      }
#      spec {
#        service_account_name = kubernetes_service_account_v1.sa_workload_identity.metadata[0].name
#        container {
#          image = "europe-west4-docker.pkg.dev/${data.google_project.project.project_id}/${google_artifact_registry_repository.repo.name}/my-app:latest"
#          name  = "spring-cloud-gcp-storage"
#
#          resources {
#            limits = {
#              cpu    = "500m"
#              memory = "1Gi"
#            }
#            requests = {
#              cpu    = "250m"
#              memory = "512Mi"
#            }
#          }
#          env {
#            name  = "GCS_BUCKET"
#            value = google_storage_bucket.demo2_bucket.name
#          }
#          liveness_probe {
#            http_get {
#              path = "/actuator/health/liveness"
#              port = 8080
#            }
#            initial_delay_seconds = 10
#            period_seconds        = 10
#          }
#          readiness_probe {
#            http_get {
#              path = "/actuator/health/readiness"
#              port = 8080
#            }
#            initial_delay_seconds = 10
#            period_seconds        = 10
#          }
#          startup_probe {
#            http_get {
#              path = "/actuator/health/liveness"
#              port = 8080
#            }
#            initial_delay_seconds = 30
#            period_seconds = 10
#          }
#        }
#      }
#    }
#  }
#
#  timeouts {
#    create = "3m"
#    update = "3m"
#    delete = "3m"
#  }
#
#  depends_on = [github_repository_file.foo]
#}
#
#resource "google_storage_bucket" "demo2_bucket" {
#  location      = "europe-west4"
#  name          = "demo2-${var.conference}"
#  force_destroy = true
#}
#
#resource "google_storage_bucket_iam_member" "sa_bucket" {
#  bucket = google_storage_bucket.demo2_bucket.name
#  member = "serviceAccount:${google_service_account.sa_bucket.email}"
#  role   = "roles/storage.objectAdmin"
#}
