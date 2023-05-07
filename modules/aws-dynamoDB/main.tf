resource "aws_dynamodb_table" "visitor_counter" {
  name           = "VisitorCounter"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

}

resource "aws_dynamodb_table_item" "visitor_counter_item" {
  table_name = aws_dynamodb_table.visitor_counter.name
  hash_key   = "id"

  item = jsonencode({
    "id"    = { "S": "visitor_count" }
    "count" = { "N": "0" }
  })
}