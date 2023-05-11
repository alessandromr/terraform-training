module "static_site_1" {
  source = "./static-site"

  env          = "dev"
  project_name = "demo-static-website-1-12-05-2023"
}
module "static_site_2" {
  source = "./static-site"

  env          = "dev"
  project_name = "demo-static-website-2-12-05-2023"
}


output "static_website_1_domain" {
  value = module.static_site_1.cloudfront_domain
}
output "static_website_2_domain" {
  value = module.static_site_2.cloudfront_domain
}


resource "aws_s3_object" "index1"{
  bucket = module.static_site_1.s3_bucket_id
  key    = "index.html"
  content = file("first_website.html")
  content_type = "text/html"
}
resource "aws_s3_object" "index2"{
  bucket = module.static_site_2.s3_bucket_id
  key    = "index.html"
  content = file("second_website.html")
  content_type = "text/html"
}