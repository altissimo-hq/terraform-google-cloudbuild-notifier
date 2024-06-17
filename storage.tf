resource "google_storage_bucket" "build-notifier" {
  count    = var.create_bucket ? 1 : 0
  name     = var.bucket
  location = var.region
  project  = var.project_id

  force_destroy               = false
  uniform_bucket_level_access = true
}

data "google_compute_default_service_account" "default" {
}

resource "google_storage_bucket_iam_member" "build-notifier-compute" {
  count  = var.create_bucket ? 1 : 0
  bucket = google_storage_bucket.build-notifier[0].name
  role   = "roles/storage.legacyObjectOwner"
  member = data.google_compute_default_service_account.default.member
}

data "google_storage_bucket" "bucket" {
  name = var.bucket
}

resource "google_storage_bucket_object" "slack-config-yaml" {
  bucket  = data.google_storage_bucket.bucket.name
  name    = var.slack_notifier_config_path
  content = local.slack_config
}

resource "google_storage_bucket_object" "slack-template-json" {
  bucket  = data.google_storage_bucket.bucket.name
  name    = var.slack_notifier_template_path
  content = local.slack_template
}
