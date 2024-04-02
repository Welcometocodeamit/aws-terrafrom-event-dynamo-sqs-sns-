resource "aws_lambda_function" "sqs_lambda" {
  filename      = "sqs_lambda.zip"  
  function_name = "sqs_lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "sqs_lambda.handler"
  runtime       = "python3.12"

  environment {
    variables = {
      SNS_TOPIC_ARN = data.aws_sns_topic.upload_notification_topic.arn
    }
  }
}

resource "aws_iam_policy_attachment" "lambda_sns_policy_attachment" {
  name       = "lambda_sns_policy_attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}



resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_sqs_policy"
  description = "IAM policy for Lambda function to access SQS queue"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sqs:*",
        Resource = aws_sqs_queue.task_one_queue.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda_basic_execution"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_exec.name]
}

resource "aws_iam_policy_attachment" "lambda_sqs_attachment" {
  name        = "sqs_attachment"
  roles       = [aws_iam_role.lambda_exec.name]
  policy_arn  = aws_iam_policy.lambda_policy.arn
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/sqs_lambda"
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_sqs_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}
 
