
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
