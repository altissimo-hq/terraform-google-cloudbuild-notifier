locals {

  default_slack_config = <<-EOT
  apiVersion: cloud-build-notifiers/v1
  kind: SlackNotifier
  metadata:
    name: ${var.service_name}
  spec:
    notification:
      filter: ${var.filter}
      params:
        source: $(build.source)
        status: $(build.status)
        substitutions: $(build.substitutions)
        triggerId: $(build.BuildTriggerId)
      delivery:
        webhookUrl:
          secretRef: webhook-url
      template:
        type: golang
        uri: gs://${var.bucket}/${var.slack_notifier_template_path}
    secrets:
    - name: webhook-url
      value: projects/${var.slack_webhook_project}/secrets/${var.slack_webhook_secret_name}/versions/${var.slack_webhook_secret_version}
  EOT

  default_slack_template = <<-EOT
  [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "Build job <{{.Build.LogUrl}}|{{.Build.Id}}> triggered by <https://console.cloud.google.com/cloud-build/triggers;region=us-central1/edit/{{.Params.triggerId}}?project={{.Build.ProjectId}}|{{.Build.Substitutions.TRIGGER_NAME}}>"
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*Project:* <{{.Build.LogUrl}}|{{.Build.ProjectId}}>"
        },
        {
          "type": "mrkdwn",
          "text": "*Repo:* <https://github.com/{{.Build.Substitutions.REPO_FULL_NAME}}|{{.Build.Substitutions.REPO_NAME}}>"
        },
        {
          "type": "mrkdwn",
          "text": "*Branch:* <https://github.com/{{.Build.Substitutions.REPO_FULL_NAME}}/tree/{{.Build.Substitutions.BRANCH_NAME}}|{{.Build.Substitutions.BRANCH_NAME}}>"
        },
        {
          "type": "mrkdwn",
          "text": "*Commit:* <https://github.com/{{.Build.Substitutions.REPO_FULL_NAME}}/commit/{{.Build.Substitutions.COMMIT_SHA}}|{{.Build.Substitutions.SHORT_SHA}}>"
        },
        {
          "type": "mrkdwn",
          "text": "*Status:* `{{.Params.status}}`"
        }
      ]
    }
  ]
  EOT

  slack_config   = coalesce(var.slack_config_yaml, local.default_slack_config)
  slack_template = coalesce(var.slack_template_json, local.default_slack_template)

}
