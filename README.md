# Altissimo - Google Cloud Build Notifier (Terraform Module)

The repo contains a terraform module for deploying the Google Cloud Build Notifier as a Cloud Run Service.

`altissimo-hq/terraform-google-cloudbuild-notifier`

## Prerequisites

### Google Cloud IAM Service Account
This Terraform module currently relies on a Google Cloud IAM Service Account that is used to send PubSub notifications to the Cloud Run service.
* `service_account`: Service Account email address (ex. "cloud-run-pubsub-invoker@<PROJECT_ID>.iam.gserviceaccount.com")

This Service Account will receive the Cloud Run Invoker role on the Cloud Run Service.

### Google Cloud Secret Manager Secret
This Terraform module currently relies on a Google Cloud Secret Manager Secret that contains a Slack Webhook where notifications are sent.
* `slack_webhook_project`: Project where the Secret lives
* `slack_webhook_secret_name`: Name of the Secret (defaults to "slack-cloudbuild-webook")
* `slack_webhook_secret_version`: Version of the Secret (defaults to "latest")

The Compute Engine Service Account needs the Secret Accessor role on the Secret:
* member: `${PROJECT_NUMBER}-compute@developer.gserviceaccount.com`
* role: `roles/secretmanager.secretAccessor`

### Google Cloud Storage Bucket
This Terraform module currently relies on a Google Cloud Storage Bucket that is used to store the Google Cloud Build Notifier config and template files.
* `bucket`: Name of the Bucket where the configs and templates live
* `slack_notifier_config_path`: Path to the Slack Notifier config (default to "slack-notifications.yaml")
* `slack_notifier_template_path`: Path to the Slack Notifier template (default to "slack-template.json")

The Compute Engine Service Account needs the Storage Legacy Object Owner role on the Bucket:
* member: `PROJECT_NUMBER-compute@developer.gserviceaccount.com`
* role: `roles/storage.legacyObjectOwner`

### PubSub Cloud Run Invoker
This Terrform module currently relies on the PubSub Service Agent has the ability to act as other IAM Service Accounts in the project.
* member: `service-PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com`
* role: `roles/iam.serviceAccountTokenCreator`
---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.33.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service.cloud-build-slack-notifier](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_member.cloud-build-slack-notifier-invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
| [google_pubsub_subscription.cloud-builds](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_topic.cloud-builds](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_storage_bucket.build-notifier](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.build-notifier-compute](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_object.slack-config-yaml](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [google_storage_bucket_object.slack-template-json](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [google_compute_default_service_account.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_default_service_account) | data source |
| [google_pubsub_topic.cloud-builds](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/pubsub_topic) | data source |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Google Storage Bucket continaing the Cloud Build Notifier configuration | `string` | n/a | yes |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Create the Bucket. Defaults to true. | `bool` | `true` | no |
| <a name="input_create_pubsub_topic"></a> [create\_pubsub\_topic](#input\_create\_pubsub\_topic) | Create the Pub/Sub Topic. Defaults to true. | `bool` | `true` | no |
| <a name="input_filter"></a> [filter](#input\_filter) | CEL filter that captures the Cloud Build messages to send to the Cloud Build Notifiers. | `string` | `"build.status in [Build.Status.SUCCESS, Build.Status.FAILURE, Build.Status.TIMEOUT]"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud Project | `string` | n/a | yes |
| <a name="input_pubsub_topic"></a> [pubsub\_topic](#input\_pubsub\_topic) | Google Cloud Pub/Sub Topic that will receive Cloud Build notifications. | `string` | `"cloud-builds"` | no |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud Region | `string` | `"us-central1"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Email address of the Service Account used to invoke the Cloud Run Service | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the Cloud Run Service to deploy | `string` | `"cloud-build-slack-notifier"` | no |
| <a name="input_slack_config_yaml"></a> [slack\_config\_yaml](#input\_slack\_config\_yaml) | YAML string representing the Slack Notifier configuration. | `any` | `null` | no |
| <a name="input_slack_notifier_config_path"></a> [slack\_notifier\_config\_path](#input\_slack\_notifier\_config\_path) | Path to the Slack Notifier config file in the Google Storage Bucket | `string` | `"slack-notifications.yaml"` | no |
| <a name="input_slack_notifier_image"></a> [slack\_notifier\_image](#input\_slack\_notifier\_image) | Container Image contining the Cloud Build Notifier for Slack | `string` | `"us-east1-docker.pkg.dev/gcb-release/cloud-build-notifiers/slack:latest"` | no |
| <a name="input_slack_notifier_template_path"></a> [slack\_notifier\_template\_path](#input\_slack\_notifier\_template\_path) | Path to the Slack Notifier template file in the Google Storage Bucket | `string` | `"slack-template.json"` | no |
| <a name="input_slack_template_json"></a> [slack\_template\_json](#input\_slack\_template\_json) | JSON string representing the Slack Notifier template. | `any` | `null` | no |
| <a name="input_slack_webhook_project"></a> [slack\_webhook\_project](#input\_slack\_webhook\_project) | Google Cloud Project containing the Slack Webhook | `string` | n/a | yes |
| <a name="input_slack_webhook_secret_name"></a> [slack\_webhook\_secret\_name](#input\_slack\_webhook\_secret\_name) | Google Cloud Secret containing the Slack Webhook | `string` | `"slack-cloudbuild-webhook"` | no |
| <a name="input_slack_webhook_secret_version"></a> [slack\_webhook\_secret\_version](#input\_slack\_webhook\_secret\_version) | Google Cloud Secret Version containing the Slack Webhook | `string` | `"latest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Bucket used by this module |
| <a name="output_pubsub_subscription"></a> [pubsub\_subscription](#output\_pubsub\_subscription) | Pub/Sub Subscription created by this module |
| <a name="output_pubsub_topic"></a> [pubsub\_topic](#output\_pubsub\_topic) | Pub/Sub Topic used by this module |
| <a name="output_service"></a> [service](#output\_service) | Cloud Run Service created by this module |
| <a name="output_slack_notifier_config"></a> [slack\_notifier\_config](#output\_slack\_notifier\_config) | Content of the Slack Notifier Config (YAML) |
| <a name="output_slack_notifier_template"></a> [slack\_notifier\_template](#output\_slack\_notifier\_template) | Content of the Slack Notifier Template (JSON) |
<!-- END_TF_DOCS -->
