provider "aws" {
  region              = "eu-central-1"
  profile             = "261496907632"
  allowed_account_ids = ["261496907632"]
}

terraform {
  required_version = "~> 0.11.14"

  backend "s3" {
    region  = "eu-central-1"
    bucket  = "omom-terraform"
    key     = "calorific-conversion.tfstate"
    profile = "261496907632"
  }
}

resource "aws_s3_bucket_object" "calorific_conversion_page" {
  bucket = "omom-website"
  key    = "calorific-conversion"
  source = "../src/index.html"
}
