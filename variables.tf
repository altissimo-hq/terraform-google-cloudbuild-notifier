variable "bucket" {
  description = "Google Storage Bucket continaing the Cloud Build Notifier configuration"
  type        = string
}

variable "create_bucket" {
  description = "Create the Bucket. Defaults to true."
  type        = bool
  default     = true
}

variable "create_pubsub_topic" {
  description = "Create the Pub/Sub Topic. Defaults to true."
  type        = bool
  default     = true
}

variable "filter" {
  description = "CEL filter that captures the Cloud Build messages to send to the Cloud Build Notifiers."
  type        = string
  default     = "build.status in [Build.Status.SUCCESS, Build.Status.FAILURE, Build.Status.TIMEOUT]"
}

variable "project_id" {
  description = "Google Cloud Project"
  type        = string
}

variable "pubsub_topic" {
  description = "Google Cloud Pub/Sub Topic that will receive Cloud Build notifications."
  type        = string
  default     = "cloud-builds"
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
  default     = "us-central1"
}

variable "service_account" {
  description = "Email address of the Service Account used to invoke the Cloud Run Service"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run Service to deploy"
  type        = string
  default     = "cloud-build-slack-notifier"
}

variable "slack_config_yaml" {
  description = "YAML string representing the Slack Notifier configuration."
  default     = null
}

variable "slack_template_json" {
  description = "JSON string representing the Slack Notifier template."
  default     = null
}

variable "slack_notifier_config_path" {
  description = "Path to the Slack Notifier config file in the Google Storage Bucket"
  default     = "slack-notifications.yaml"
}

variable "slack_notifier_template_path" {
  description = "Path to the Slack Notifier template file in the Google Storage Bucket"
  default     = "slack-template.json"
}

variable "slack_notifier_image" {
  description = "Container Image contining the Cloud Build Notifier for Slack"
  default     = "us-east1-docker.pkg.dev/gcb-release/cloud-build-notifiers/slack:latest"
}

variable "slack_webhook_project" {
  description = "Google Cloud Project containing the Slack Webhook"
  type        = string
}

variable "slack_webhook_secret_name" {
  description = "Google Cloud Secret containing the Slack Webhook"
  type        = string
  default     = "slack-cloudbuild-webhook"
}

variable "slack_webhook_secret_version" {
  description = "Google Cloud Secret Version containing the Slack Webhook"
  type        = string
  default     = "latest"
}
