resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.bucket_endpoint
    origin_id = var.bucket_id

    s3_origin_config {
      origin_access_identity = ""
    }
  }

    enabled             = true
    is_ipv6_enabled     = true
    comment             = "CloudFront Distribution for ${var.domain_name}"
    default_root_object = "index.html"
    aliases = [var.domain_name]
    price_class = "PriceClass_100"

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = var.bucket_id

    forwarded_values {
        query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

  }

    viewer_certificate {
    acm_certificate_arn      = var.cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CloudFront Distribution for ${var.domain_name}"
  }

}
