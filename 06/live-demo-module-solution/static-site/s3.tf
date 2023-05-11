data "aws_iam_policy_document" "static-website-bucket" {
  policy_id = "${var.project_name}-${var.env}"
  statement {
    sid = "PolicyForCloudFrontPrivateContent"
    principals {
      type = "AWS"
      identifiers = [
      aws_cloudfront_origin_access_identity.static-website-oai.iam_arn]
    }
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.project_name}-${var.env}/*",
      "arn:aws:s3:::${var.project_name}-${var.env}"
    ]
  }
  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type = "*"
      identifiers = [
      "*"]
    }
    effect = "Deny"
    actions = [
    "s3:*"]
    resources = [
      "arn:aws:s3:::${var.project_name}-${var.env}/*",
      "arn:aws:s3:::${var.project_name}-${var.env}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
      "false"]
    }
  }
}

resource "aws_s3_bucket" "static-website-s3" {
  bucket = "${var.project_name}-${var.env}"

  tags = {
    Name = "demo-proj-static-website"
  }
}

resource "aws_s3_bucket_versioning" "static-website-s3" {
  bucket = aws_s3_bucket.static-website-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "static-website-s3" {
  bucket = aws_s3_bucket.static-website-s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_policy" "static-website-s3" {
  bucket = aws_s3_bucket.static-website-s3.id
  policy = data.aws_iam_policy_document.static-website-bucket.json
}

resource "aws_s3_bucket_public_access_block" "static-website-s3" {
  bucket = aws_s3_bucket.static-website-s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}