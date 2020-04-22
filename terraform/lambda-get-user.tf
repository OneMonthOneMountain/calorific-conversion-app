data "archive_file" "get_user_lamba" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/get-user"
  output_path = "${path.module}/files/get-user.zip"
}

resource "aws_lambda_function" "get_user_lamba" {
  function_name    = "get-user"
  filename         = "${data.archive_file.get_user_lamba.output_path}"
  role             = "${aws_iam_role.lambda.arn}"
  source_code_hash = "${filebase64sha256(data.archive_file.get_user_lamba.output_path)}"

  handler = "index.handler"
  runtime = "nodejs12.x"
}
