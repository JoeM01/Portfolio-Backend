output "zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output "dist_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "dist_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}