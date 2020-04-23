
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

resource "aws_s3_bucket_object" "calculator" {
  bucket = "omom-website"
  key    = "hiking-calculator.html"
  source = "../website/hiking-calculator.html"

  etag = "${filemd5("../website/hiking-calculator.html")}"

  content_type = "text/html"
}
