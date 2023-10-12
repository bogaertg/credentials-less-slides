#resource "kubernetes_deployment_v1" "spring_cloud_gcp_storage" {
#  metadata {
#    name = "spring-petclinic"
#  }
#
#  spec {
#    replicas = 1
#    selector {
#      match_labels = {
#        test = "spring-petclinic"
#      }
#    }
#
#    template {
#      metadata {
#        labels = {
#          test = "spring-petclinic"
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
#            name  = "POSTGRES_USER"
#            value = "root"
#          }
#          env {
#            name  = "POSTGRES_PASSWORD"
#            value = google_sql_database_instance.instance.root_password
#          }
#          env {
#            name  = "POSTGRES_URL"
#            value = "jdbc:postgresql://${google_sql_database_instance.instance.public_ip_address}:5432/my-database"
#          }
#
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
#            period_seconds        = 10
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

resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance"
  database_version = "POSTGRES_15"
  region = "europe-west4"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true

      authorized_networks {
        value = "0.0.0.0/0"
      }
    }
  }

  deletion_protection = "false"
}

resource "google_sql_user" "postgres" {
  name     = "postgres"
  instance = google_sql_database_instance.instance.name
  password = "password"
}

resource "google_sql_user" "my-app" {
  name     = "my-app"
  instance = google_sql_database_instance.instance.name
  password = "password"
}

resource "local_file" "demo" {
  content  = templatefile( "${path.module}/template/demo.md.tftpl",{CLOUD_SQL_IP = google_sql_database_instance.instance.public_ip_address} )
  filename = "${path.module}/demo.md"
}

resource "local_file" "deployment" {
  content  = templatefile( "${path.module}/template/deployment.yaml.tftpl",{CLOUD_SQL_IP = google_sql_database_instance.instance.public_ip_address} )
  filename = "${path.module}/k8s/deployment.yaml"
}
