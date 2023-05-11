resource "aws_cloudfront_origin_access_identity" "static-website-oai" {
  comment = "${var.project_name}-oai-${var.env}"
}

resource "aws_cloudfront_distribution" "s3-distribution-static-website" {

  origin {
    domain_name = aws_s3_bucket.static-website-s3.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.static-website-s3.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static-website-oai.cloudfront_access_identity_path
    }
  }

  enabled = true

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.static-website-s3.id

    forwarded_values {
      headers = ["Origin", "Authorization", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
      cookies {
        forward = "none"
      }
      query_string = false
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  tags = {
    Env = var.env
  }
}