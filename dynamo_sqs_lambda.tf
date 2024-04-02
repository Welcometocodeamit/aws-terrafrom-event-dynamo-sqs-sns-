resource "aws_lambda_function" "dynamodb_to_sqs_lambda" {
  filename      = "stream.zip"
  function_name = "dynamodb_to_sqs_lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "stream.lambda_handler"
  runtime       = "python3.12"

  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.task_one_queue.id
    }
  }
}

resource "aws_lambda_permission" "allow_dynamodb" {
  statement_id  = "AllowExecutionFromDynamoDB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamodb_to_sqs_lambda.function_name
  principal     = "dynamodb.amazonaws.com"
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "lambda_dynamodb_policy"
  description = "IAM policy for Lambda function to access DynamoDB stream"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams"
        ],
        Resource = aws_dynamodb_table.task-one-table.stream_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}




resource "aws_sqs_queue" "task_one_queue" {
  name                      = "task-one-queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  visibility_timeout_seconds = 30
}

output "sqs_queue_url" {
  value = aws_sqs_queue.task_one_queue.id
}
