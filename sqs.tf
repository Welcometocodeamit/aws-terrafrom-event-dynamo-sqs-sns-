# resource "aws_sqs_queue" "task_one_queue" {
#   name                      = "task-one-queue"
#   delay_seconds             = 0
#   max_message_size          = 2048
#   message_retention_seconds = 86400
#   visibility_timeout_seconds = 30
# }
