#module "static_website" {
#  source = "./static_website"
#
#  project_name = "terraform-demo-12-05-2023"
#  env = "staging"
#}
#
#resource "aws_s3_object" "static_website_index" {
#  bucket = module.static_website.s3_bucket_id
#  key    = "index.html"
#  content = file("./index.html")
#
#  content_type = "text/html"
#}
#
#output "static_website_domain" {
#  value = module.static_website.domain
#}
#output "static_website_s3_bucket" {
#  value = module.static_website.s3_bucket_id
#}
