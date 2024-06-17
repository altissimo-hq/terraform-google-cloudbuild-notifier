output "bucket" {
  description = "Bucket used by this module"
  value       = data.google_storage_bucket.bucket.id
}

output "pubsub_subscription" {
  description = "Pub/Sub Subscription created by this module"
  value       = google_pubsub_subscription.cloud-builds.id
}

output "pubsub_topic" {
  description = "Pub/Sub Topic used by this module"
  value       = data.google_pubsub_topic.cloud-builds.id
}

output "service" {
  description = "Cloud Run Service created by this module"
  value       = google_cloud_run_service.cloud-build-slack-notifier.id
}

output "slack_notifier_config" {
  description = "Content of the Slack Notifier Config (YAML)"
  value       = local.slack_config
}

output "slack_notifier_template" {
  description = "Content of the Slack Notifier Template (JSON)"
  value       = local.slack_template
}
