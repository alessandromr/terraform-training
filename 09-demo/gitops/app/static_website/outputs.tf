output "domain" {
  value = aws_cloudfront_distribution.static_website.domain_name
}
output "s3_bucket_id" {
  value = aws_s3_bucket.static_website_bucket.id
}