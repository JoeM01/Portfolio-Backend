output "hosted_zone_id" {
  value = aws_route53_zone.joemartinezportfolio_zone.zone_id
}

output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}