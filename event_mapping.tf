resource "aws_lambda_event_source_mapping" "sqs_mapping" {
  event_source_arn = aws_sqs_queue.task_one_queue.arn
  function_name    = aws_lambda_function.sqs_lambda.function_name
}
