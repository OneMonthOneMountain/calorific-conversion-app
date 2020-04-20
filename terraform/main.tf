resource "aws_s3_bucket_object" "calorific_conversion_page" {
   bucket = "omom-website"
  key    = "calorific-conversion"
  source = "../src/index.html"
}
