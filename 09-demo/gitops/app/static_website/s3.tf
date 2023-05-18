resource "aws_s3_bucket" "static_website_bucket" {
  bucket = "${var.project_name}-${var.env}"
}

resource "aws_s3_bucket_versioning" "static_website_bucket" {
  bucket = aws_s3_bucket.static_website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "static_website_bucket" {
  bucket = aws_s3_bucket.static_website_bucket.id
}

resource "aws_s3_bucket_policy" "static_website_bucket" {
  bucket = aws_s3_bucket.static_website_bucket.id
  policy = data.aws_iam_policy_document.static_website_bucket.json
}

data "aws_iam_policy_document" "static_website_bucket" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "s3:GetObject"
    ]
    condition {
      test     = "StringEquals"
      values   = [
        aws_cloudfront_distribution.static_website.arn
      ]
      variable = "AWS:SourceArn"
    }
    resources = [
      "${aws_s3_bucket.static_website_bucket.arn}/*"
    ]
  }
}
