terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.76.0"
    }
  }

  backend "gcs" {
    bucket      = "allu-gcf-tfstate"
    prefix      = "allu-gcf/tfstate"
    credentials = "./service-account-key.json"
  }

  required_version = ">= 1.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  suffix = terraform.workspace
  common_tags = {
    environment  = terraform.workspace
    project_name = "allu-gcf"
  }

  contentful_env = {
    test = "test"
    prod = "master"
  }
}

resource "google_storage_bucket" "function_bucket" {
  name     = "allu-gcf-bucket"
  location = "europe-west1"
}

resource "google_storage_bucket_iam_member" "function_bucket_iam" {
  bucket = google_storage_bucket.function_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.project_id}@appspot.gserviceaccount.com"
}
