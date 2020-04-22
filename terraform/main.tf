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
