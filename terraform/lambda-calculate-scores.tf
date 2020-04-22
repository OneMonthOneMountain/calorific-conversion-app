data "archive_file" "calculate_scores_lamba" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/calculate-scores"
  output_path = "${path.module}/files/calculate-scores.zip"
}

resource "aws_lambda_function" "calculate_scores_lambda" {
  function_name    = "calculate-scores"
  filename         = "${data.archive_file.calculate_scores_lamba.output_path}"
  role             = "${aws_iam_role.lambda.arn}"
  source_code_hash = "${filebase64sha256(data.archive_file.calculate_scores_lamba.output_path)}"

  handler = "index.handler"
  runtime = "nodejs12.x"
}

resource "aws_lambda_event_source_mapping" "lambda_trigger" {
  event_source_arn  = "${aws_dynamodb_table.table.stream_arn}"
  function_name     = "${aws_lambda_function.calculate_scores_lambda.arn}"
  starting_position = "LATEST"

  maximum_retry_attempts = 1

  batch_size = 1
}
