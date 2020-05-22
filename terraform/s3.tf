resource "aws_s3_bucket" "virtual_hiker" {
  bucket = "omom-virtual-hiker"
  acl    = "public-read"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::omom-virtual-hiker/*"
        }
    ]
}
POLICY

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  website {
    index_document = "calorific-conversion.html"
    error_document = "calorific-conversion.html"
  }
}

resource "aws_s3_bucket_object" "calorific_conversion_page" {
  bucket = "omom-website"
  key    = "calorific-conversion.html"
  source = "../website/calorific-conversion.html"

  etag = "${filemd5("../website/calorific-conversion.html")}"

  content_type = "text/html"
}

resource "aws_s3_bucket_object" "leaderboard_page" {
  bucket = "omom-website"
  key    = "leaderboard.html"
  source = "../website/leaderboard.html"

  etag = "${filemd5("../website/leaderboard.html")}"

  content_type = "text/html"
}

resource "aws_s3_bucket_object" "user_page" {
  bucket = "omom-website"
  key    = "user.html"
  source = "../website/user.html"

  etag = "${filemd5("../website/user.html")}"

  content_type = "text/html"
}
