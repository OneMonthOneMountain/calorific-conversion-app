resource "aws_dynamodb_table" "table" {
  name         = "scores"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "UserId"
    type = "S"
  }
}
