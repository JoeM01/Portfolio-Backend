resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

    tags = {
      Name = "Portfolio site host"
      Enviroment = "Prod"
    }

}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = data.aws_iam_policy_document.allow_public_access_to_bucket.json
}

data "aws_iam_policy_document" "allow_public_access_to_bucket" {
  statement {
    actions = ["s3:GetObject"]
    effect = "Allow"
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_website_configuration" "web_bucket" {
    bucket = aws_s3_bucket.bucket.id

    index_document {
      suffix = "index.html"
    }
}

resource "aws_s3_object" "html"{
    key = "index.html"
    source = "src/index.html"
    bucket = aws_s3_bucket.bucket.id
    etag = filemd5("src/index.html")
    content_type = "text/html"
}

resource "aws_s3_object" "css"{
    key = "style.css"
    source = "src/style.css"
    bucket = aws_s3_bucket.bucket.id
    etag = filemd5("src/style.css")
    content_type = "text/css"
}

resource "aws_s3_object" "js"{
    key = "counter.js"
    source = "src/counter.js"
    bucket = aws_s3_bucket.bucket.id
    etag = filemd5("src/counter.js")
    content_type = "application/x-javascript"
}