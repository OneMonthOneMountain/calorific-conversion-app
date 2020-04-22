resource "aws_api_gateway_rest_api" "api" {
  name        = "scores"
  description = "API for updating peoples scores"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    "aws_api_gateway_method.register_user",
    "aws_api_gateway_integration.register_user",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "default"
}

### Register User

resource "aws_api_gateway_resource" "register_user" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "register-user"
}

resource "aws_api_gateway_method" "register_user" {
  rest_api_id      = "${aws_api_gateway_rest_api.api.id}"
  resource_id      = "${aws_api_gateway_resource.register_user.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = "false"
}

resource "aws_api_gateway_integration" "register_user" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.register_user.id}"
  http_method = "${aws_api_gateway_method.register_user.http_method}"
  type        = "AWS_PROXY"

  uri                     = "${aws_lambda_function.register_user_lamba.invoke_arn}"
  integration_http_method = "POST"
}

resource "aws_lambda_permission" "register_user" {
  statement_id  = "AllowAPIGateway-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.register_user_lamba.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.deployment.execution_arn}/*"

  lifecycle {
    create_before_destroy = true
  }
}

### Get User

resource "aws_api_gateway_resource" "get_user" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "get-user"
}

resource "aws_api_gateway_method" "get_user" {
  rest_api_id      = "${aws_api_gateway_rest_api.api.id}"
  resource_id      = "${aws_api_gateway_resource.get_user.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = "false"
}

resource "aws_api_gateway_integration" "get_user" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.get_user.id}"
  http_method = "${aws_api_gateway_method.get_user.http_method}"
  type        = "AWS_PROXY"

  uri                     = "${aws_lambda_function.get_user_lambda.invoke_arn}"
  integration_http_method = "POST"
}

resource "aws_lambda_permission" "get_user" {
  statement_id  = "AllowAPIGateway-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_user_lambda.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.deployment.execution_arn}/*"

  lifecycle {
    create_before_destroy = true
  }
}
