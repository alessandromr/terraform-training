provider "google" {
  project     = "tf-training-386313"
  region      = "europe-west12"

  credentials = file("/Users/alessandromarino/.gcp/tf-training-386313-669332f07266.json")
}