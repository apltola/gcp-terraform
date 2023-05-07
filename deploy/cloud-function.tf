/*
 * Deployment of a Google Cloud Function
 * /app directory is packaged into a .zip file which is used as a source code for the function
 * The .zip file is pushed into a cloud storage bucket, and the cloud function pulls the source code from there
*/

// Resource block to generate a random id for the .zip file containing the app code
resource "random_id" "suffix" {
  byte_length = 4

  // This forces terraform to apply this block every time `terraform apply` is executed
  keepers = {
    timestamp = timestamp()
  }
}

// Data block to create a ZIP file from the cloud function app code (directory `app`)
data "archive_file" "function_code" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/jeppis-function-${local.suffix}-${random_id.suffix.hex}.zip"
}

// Resource block to upload the ZIP file to the Google Cloud Storage bucket
resource "google_storage_bucket_object" "function_code" {
  name   = "jeppis-function-${local.suffix}-${random_id.suffix.hex}.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_code.output_path

  // Remove the .zip file from local filesystem after it has been deployed
  provisioner "local-exec" {
    command = "rm ${data.archive_file.function_code.output_path}"
    on_failure = continue
  }
}

// Resource block to create a Google Cloud Function
resource "google_cloudfunctions_function" "my_function" {
  depends_on = [google_storage_bucket_object.function_code]

  project     = var.project_id
  region      = var.region
  name        = "jeppis-function-${local.suffix}"
  runtime     = "nodejs18"
  entry_point = "main"

  // Configure the source code for the function to be the bucket containing .zip file
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = "jeppis-function-${local.suffix}-${random_id.suffix.hex}.zip"

  environment_variables = {
    NODE_ENV                    = "production"
    CONTENTFUL_SPACE_ID         = var.contentful_space_id
    CONTENTFUL_ENV              = local.contentful_env[terraform.workspace]
    CONTENTFUL_MANAGEMENT_TOKEN = var.contentful_management_token
  }

  // Function will be triggered from a message in a pubsub topic
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = "projects/${var.project_id}/topics/my-topic-${local.suffix}"
  }

  timeout             = 60
  available_memory_mb = 256

  labels = local.common_tags
}
