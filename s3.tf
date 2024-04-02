resource "aws_s3_bucket" "task_one" {
  bucket = "gdtc-task-one-amit"
}

resource "aws_s3_object" "file_object" {
  bucket = aws_s3_bucket.task_one.bucket
  key    = "MOCK_DATA.csv"
  source = "MOCK_DATA.csv"
}