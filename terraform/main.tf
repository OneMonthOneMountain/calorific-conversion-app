provider "aws" {
  region              = "eu-west-2"
  profile             = "261496907632"
  allowed_account_ids = ["261496907632"]
}

terraform {
  backend "s3" {
    region  = "eu-west-2"
    bucket  = "omom-terraform"
    key     = "calorific-conversion.tfstate"
    profile = "261496907632"
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

resource "aws_s3_bucket_object" "login_page" {
  bucket = "omom-website"
  key    = "login.html"
  source = "../website/login.html"

  etag = "${filemd5("../website/login.html")}"

  content_type = "text/html"
}

resource "aws_s3_bucket_object" "css" {
  bucket = "omom-website"
  key    = "calorific-conversion.css"
  source = "../website/calorific-conversion.css"

  etag = "${filemd5("../website/calorific-conversion.css")}"

  content_type = "text/html"
}
