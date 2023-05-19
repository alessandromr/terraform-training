data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-demo-bucket-2023-05-11"
    key    = "demo/ec2-advanced-demo/network.json"
    region = "eu-west-1"
  }
}