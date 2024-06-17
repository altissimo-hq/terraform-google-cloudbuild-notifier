resource "google_pubsub_topic" "cloud-builds" {
  count   = var.create_pubsub_topic ? 1 : 0
  name    = var.pubsub_topic
  project = var.project_id

  labels = {
    service = "cloud-build-notifier"
  }

}

data "google_pubsub_topic" "cloud-builds" {
  name = var.pubsub_topic
}

resource "google_pubsub_subscription" "cloud-builds" {
  name  = "cloud-builds-notifier"
  topic = data.google_pubsub_topic.cloud-builds.id

  labels = {
    service = "cloud-build-notifier"
  }

  push_config {
    oidc_token {
      service_account_email = var.service_account
    }
    push_endpoint = google_cloud_run_service.cloud-build-slack-notifier.status[0].url
  }
}
