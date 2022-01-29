resource "aws_cloudfront_origin_access_identity" "website_oai" {
  comment = "Website's Cloudfront OAI"
}

locals {
  origin_name = aws_s3_bucket.website.bucket_regional_domain_name
  error_ttl   = 7200
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.origin_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = local.error_ttl
    error_code            = 404
    response_code         = 200
    response_page_path    = "/error.html"
  }

  custom_error_response {
    error_caching_min_ttl = local.error_ttl
    error_code            = 403
    response_code         = 200
    response_page_path    = "/error.html"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_name
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
