resource "google_artifact_registry_repository" "repo" {
  location      = "europe-west4"
  repository_id = "repo-1"

  format = "DOCKER"

  depends_on = [time_sleep.gar_sleeper]
}

resource "google_service_account" "gar_pusher" {
  account_id = "gar-pusher"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  project    = google_artifact_registry_repository.repo.project
  location   = google_artifact_registry_repository.repo.location
  repository = google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.gar_pusher.email}"
}

resource "google_service_account_key" "gar_pusher" {
  service_account_id = google_service_account.gar_pusher.id
}

resource "google_service_account_iam_member" "admin-account-iam" {
  service_account_id = google_service_account.gar_pusher.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.gar_pusher.email}"
}

resource "time_sleep" "github_repo_sleeper" {
  create_duration = "30s"
}

resource "time_sleep" "workflow_repo_sleeper" {
  create_duration = "90s"
  depends_on      = [google_service_account_iam_binding.gar_pusher_workload_identity_binding]
}

resource "github_repository" "demo1" {
  name = "credentials-less-${var.conference}-demo1"

  visibility           = "public"
  vulnerability_alerts = true

  template {
    owner                = "bogaertg"
    repository           = "credentials-less-slides-demo1"
    include_all_branches = false

  }

  depends_on = [time_sleep.github_repo_sleeper]
}

resource "github_actions_secret" "google_sa_key" {
  repository      = github_repository.demo1.name
  secret_name     = "GCP_CREDENTIALS"
  plaintext_value = google_service_account_key.gar_pusher.private_key
}

resource "github_actions_variable" "google_registry_url" {
  repository    = github_repository.demo1.name
  variable_name = "GAR_REGISTRY"
  value         = "europe-west4-docker.pkg.dev/${data.google_project.project.project_id}/${google_artifact_registry_repository.repo.name}"
}

resource "random_integer" "workload_identity_pool_id" {
  min = 1
  max = 50000
  keepers = {
    date = formatdate("DD", timestamp())
  }
}

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-pool-${random_integer.workload_identity_pool_id.result}"
}

resource "google_iam_workload_identity_pool_provider" "github_repo" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-repo"
  attribute_condition                = "assertion.repository_owner == \"bogaertg\""
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_binding" "gar_pusher_workload_identity_binding" {
  service_account_id = google_service_account.gar_pusher.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${github_repository.demo1.full_name}",
  ]
}

resource "github_actions_variable" "google_workload_identity_provider" {
  repository    = github_repository.demo1.name
  variable_name = "WORKLOAD_IDENTITY_PROVIDER"
  value         = google_iam_workload_identity_pool_provider.github_repo.name
}

resource "github_actions_variable" "google_service_account_name" {
  repository    = github_repository.demo1.name
  variable_name = "SERVICE_ACCOUNT_NAME"
  value         = google_service_account.gar_pusher.email
}

resource "github_repository_file" "foo" {
  repository          = github_repository.demo1.name
  branch              = "main"
  file                = "README.md"
  content             = "# First Commit"
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [github_actions_variable.google_registry_url, github_actions_variable.google_service_account_name, github_actions_variable.google_workload_identity_provider, time_sleep.workflow_repo_sleeper]
}
