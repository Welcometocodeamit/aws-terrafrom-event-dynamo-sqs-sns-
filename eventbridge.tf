resource "aws_cloudwatch_event_rule" "lambda_trigger_rule" {
  name        = "lambda-trigger-rule"
  description = "Event rule to trigger Lambda function at specific time"
  schedule_expression = "cron(02 04 * * ? *)"  
}

# EventBridge target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger_rule.name
  target_id = "lambda-target"
  arn       = aws_lambda_function.csv_to_dynamodb.arn
}

