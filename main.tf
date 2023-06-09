terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
      }
      
    }
    backend "s3" {
        bucket         = "joes-portfolio-back-end-state-bucket"
        key            = "terraform-state"
        region         = "us-east-1"
      }
}

provider "aws" {
  region = "us-east-1"
}


module "s3_bucket" {
  source = "./modules/aws-s3-static-site"

  bucket_name = "joes-cloud-resume-terraform-bucket"
}

module "route53_acm" {
  source = "./modules/aws-route53-acm"
  domain_name = "joe-martinez.com"
  cloudfront_domain = module.cloudfront_distribution.dist_domain
  cloudfront_zone_id = module.cloudfront_distribution.zone_id
}

module "cloudfront_distribution" {
  source = "./modules/aws_cloudfront_dist"
  bucket_id = module.s3_bucket.bucket_id
  bucket_endpoint = module.s3_bucket.website_endpoint
  cert_arn = module.route53_acm.cert_arn
  domain_name = "joe-martinez.com"
}

module "dynamoDB" {
  source = "./modules/aws-dynamoDB"
}

module "lambda_function" {
  source = "./modules/lambda-function"

  db_arn = module.dynamoDB.db_arn
}

module "API_gateway" {
  source = "./modules/aws_api_gateway"

  lambda_arn = module.lambda_function.lambda_invoke_arn
  lambda_name = module.lambda_function.lambda_name
}