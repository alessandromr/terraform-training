terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "terraform-demo-bucket-2023-05-11"
    dynamodb_table = "terraform-demo-table-2023-05-11"
    key    = "demo/state.json"
    region = "eu-west-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}