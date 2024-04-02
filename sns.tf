resource "aws_sns_topic" "upload_notification_topic" {
  name = "upload_notification_topic"
}
 
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.upload_notification_topic.arn
  protocol  = "email"
  endpoint  = "amit.ytfsd@gmail.com"
}



output "sns_topic_arn" {
  value = aws_sns_topic.upload_notification_topic.arn
}

data "aws_sns_topic" "upload_notification_topic" {
  name = aws_sns_topic.upload_notification_topic.name
}