resource "aws_cloudfront_origin_access_identity" "oai" {
  for_each = local.cloudfront_iterator

  comment = "OAI for notes.securedinvestmentcorp.com site hosting from s3"
}

resource "aws_cloudfront_distribution" "cdn" {
  for_each = local.cloudfront_iterator

  aliases     = [var.domain]
  comment     = var.domain
  price_class = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = "${var.domain}-s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai["cdn"].cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = basename(var.index_document)

  default_cache_behavior {
    allowed_methods        = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "${var.domain}-s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.error_document != "" ? toset(["403", "404"]) : toset([])

    content {
      error_code            = tonumber(custom_error_response.value)
      response_page_path    = var.error_document
      response_code         = 200
      error_caching_min_ttl = 300
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null ? true : false
    acm_certificate_arn            = var.acm_certificate_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Name = var.domain
  }
}
