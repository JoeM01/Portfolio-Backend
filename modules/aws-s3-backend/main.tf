resource "aws_s3_bucket" "frontend_bucket" {
    bucket = "joes-portfolio-back-end-state-bucket"

    tags = {
      Name = "Frontend State Bucket"
      Enviroment = "Prod"
    }
  
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.frontend_bucket.id

    versioning_configuration {
      status = "Enabled"
    }
  
}