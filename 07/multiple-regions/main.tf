terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "ireland"
  region = "eu-west-1"
}

provider "aws" {
  alias = "milan"
  region = "eu-south-1"
}