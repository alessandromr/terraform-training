terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("/Users/alessandromarino/.gcp/tf-training-386313-669332f07266.json")

  project = "tf-training-386313"
  region  = "europe-west12"
  zone    = "europe-west12-a"
}