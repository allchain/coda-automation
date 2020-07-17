locals {
  k8s_context = "minikube"
  gke_project = "o1labs-192920"
}

resource "google_service_account" "gcp_buildkite_account" {
  count = var.enable_gcs_access ? 1 : 0

  account_id   = var.cluster_name
  display_name = "Buildkite Agent Cluster (${var.cluster_name}) service account"
  description  = "GCS service account for Buildkite cluster ${var.cluster_name}"
  project      = local.gke_project
}

# resource "google_project_iam_member" "buildkite_artifact_admin" {
#   count = var.enable_gcs_access ? 1 : 0

#   project = local.gke_project
#   role    = "roles/storage.objectCreator"
#   member  = "serviceAccount:${google_service_account.gcp_buildkite_account[0].email}"

#   # TODO: determine necessity of this condition
#   # condition {
#   #   title       = "buildkite-artifacts"
#   #   expression  = "resource.name.startsWith(\"buildkite\")"
#   # }
# }

resource "google_service_account_key" "buildkite_svc_key" {
  count = var.enable_gcs_access ? 1 : 0

  service_account_id = google_service_account.gcp_buildkite_account[0].name
}
