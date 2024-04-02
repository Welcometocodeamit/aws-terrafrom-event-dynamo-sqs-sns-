resource "aws_dynamodb_table" "task-one-table" {
  name = "taskOneTable"
  read_capacity = 1
  write_capacity = 1
  hash_key = "id"
 
  attribute {
    name = "id"
    type = "S"  
  }

  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}

output "dynamodb_stream_arn" {
  value = aws_dynamodb_table.task-one-table.stream_arn
}

resource "aws_lambda_event_source_mapping" "dynamodb_event_mapping" {
  event_source_arn  = aws_dynamodb_table.task-one-table.stream_arn
  function_name     = aws_lambda_function.dynamodb_to_sqs_lambda.function_name
  starting_position = "LATEST"
}