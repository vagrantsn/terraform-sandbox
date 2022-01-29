resource "aws_s3_bucket" "website" {
  bucket = "tf-website-bucket"

  lifecycle_rule {
    id      = "versions-clear"
    enabled = true
    prefix  = "/versions"

    noncurrent_version_expiration {
      days = 1
    }
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  version = "2012-10-17"

  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "${aws_cloudfront_origin_access_identity.website_oai.iam_arn}"
      ]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.website.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_object" "home" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "index.html"
  source       = "public/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "error.html"
  source       = "public/error.html"
  content_type = "text/html"
}
