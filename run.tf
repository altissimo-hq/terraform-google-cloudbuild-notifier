resource "google_cloud_run_service" "cloud-build-slack-notifier" {
  name     = var.service_name
  project  = var.project_id
  location = var.region

  metadata {
    labels = {
      service = "cloud-build-notifier"
    }
  }

  template {
    spec {
      containers {
        image = var.slack_notifier_image
        env {
          name  = "CONFIG_PATH"
          value = "gs://${var.bucket}/${var.slack_notifier_config_path}"
        }
        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }
      }
    }
  }

  lifecycle {
    replace_triggered_by = [
      google_storage_bucket_object.slack-config-yaml,
      google_storage_bucket_object.slack-template-json,
    ]
  }
}

resource "google_cloud_run_service_iam_member" "cloud-build-slack-notifier-invoker" {
  project  = google_cloud_run_service.cloud-build-slack-notifier.project
  location = google_cloud_run_service.cloud-build-slack-notifier.location
  service  = google_cloud_run_service.cloud-build-slack-notifier.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${var.service_account}"
  depends_on = [
    google_cloud_run_service.cloud-build-slack-notifier,
  ]
  lifecycle {
    replace_triggered_by = [
      google_cloud_run_service.cloud-build-slack-notifier,
    ]
  }

}
