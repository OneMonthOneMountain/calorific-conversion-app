data "archive_file" "register_user_lamba" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/register-user"
  output_path = "${path.module}/files/register-user.zip"
}

resource "aws_lambda_function" "register_user_lamba" {
  function_name    = "register-user"
  filename         = "${data.archive_file.register_user_lamba.output_path}"
  role             = "${aws_iam_role.lambda.arn}"
  source_code_hash = "${filebase64sha256(data.archive_file.register_user_lamba.output_path)}"

  handler = "index.handler"
  runtime = "nodejs12.x"
}
