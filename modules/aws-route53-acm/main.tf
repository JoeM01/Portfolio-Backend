resource "aws_route53_zone" "joemartinezportfolio_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "alias" {
  name = var.domain_name
  type = "A"
  zone_id = aws_route53_zone.joemartinezportfolio_zone.zone_id
  alias {
    name = var.cloudfront_domain
    zone_id = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aaaa_record" {
  zone_id = aws_route53_zone.joemartinezportfolio_zone.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "ACM Certificate for ${var.domain_name}"
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.joemartinezportfolio_zone.zone_id
}

resource "aws_acm_certificate_validation" "certvalidation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}