locals {
  bucket_name = "${var.bucket_name}-${var.environment}"
  origin_id   = "S3-${local.bucket_name}"
  www_files   = fileset("${path.module}/www", "**")

}

resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

output "name" {
  value = aws_s3_bucket.example.bucket

}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cloudfront_origin_access_control" "example" {
  name                              = "S3-access-cloudfront"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.example.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "s3-policy" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}



resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.example.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.example.id
    origin_id                = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.example.id
  for_each     = toset(local.www_files)
  key          = each.value
  source       = "${path.module}/www/${each.value}"
  etag         = filemd5("${path.module}/www/${each.value}")
  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")

  depends_on = [aws_s3_bucket_policy.s3-policy]
}





output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

