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

data "archive_file" "lamba" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/files/lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "scores-lambda"
  filename         = "${data.archive_file.lamba.output_path}"
  role             = "${aws_iam_role.lambda.arn}"
  source_code_hash = "${filebase64sha256(data.archive_file.lamba.output_path)}"

  handler = "index.handler"
  runtime = "nodejs12.x"
}

resource "aws_iam_role" "lambda" {
  name = "scores-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name = "scores-lambda"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "S3:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda" {
  name = "scores_lambda"

  roles = [
    "${aws_iam_role.lambda.name}",
  ]

  policy_arn = "${aws_iam_policy.lambda.arn}"
}

resource "aws_dynamodb_table" "table" {
  name         = "scores"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }
}

resource "aws_lambda_event_source_mapping" "lambda_trigger" {
  event_source_arn  = "${aws_dynamodb_table.table.stream_arn}"
  function_name     = "${aws_lambda_function.lambda.arn}"
  starting_position = "LATEST"

  batch_size = 1
}
