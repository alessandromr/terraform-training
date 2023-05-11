output "cloudfront_domain" {
  value = aws_cloudfront_distribution.s3-distribution-static-website.domain_name
}
output "s3_bucket_id" {
  value = aws_s3_bucket.static-website-s3.id
}