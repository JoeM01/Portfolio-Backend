variable "bucket_id" {
  description = "ID for S3 Bucket"
  type = string
}

variable "bucket_endpoint" {
  description = "Website endpoint for the S3 Bucket"
  type = string
}

variable "cert_arn" {
  description = "ARN for domain SSL certificate"
  type = string
}

variable "domain_name" {
  description = "Route53 Domain for website"
  type = string
}