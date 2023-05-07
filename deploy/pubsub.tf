resource "google_pubsub_topic" "my_topic" {
  name = "my-topic-${local.suffix}"
}

resource "google_pubsub_subscription" "my_subscription" {
  name  = "my-pubsub-subscription-${local.suffix}"
  topic = google_pubsub_topic.my_topic.name
  push_config {
    push_endpoint = "https://${var.region}-${var.project_id}.cloudfunctions.net/jeppis-function-${local.suffix}"
  }
}