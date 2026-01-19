module "s3" {
  source      = "./modules/s3"
  bucket_name = "my-upload-bucket-pipeline-project3-sk"
  lambda_arn  = module.lambda.lambda_arn
  tags        = { Project = "EventPipeline" }
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "event_data"
  hash_key   = "id"
  tags = {
    Project = "EventPipeline"
  }
}

module "lambda" {
  source        = "./modules/lambda"
  function_name = "process_uploaded_file"
  handler       = "processor.lambda_handler"
  runtime       = "python3.11"
  filename      = "../lambda/processor.zip"
  environment = {
    TABLE_NAME = module.dynamodb.table_name
  }
  #dlq_arn = aws_sqs_queue.dlq.arn
  tags = { Project = "EventPipeline" }
}

# Lambda S3 Event Trigger
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3.bucket_arn
}

resource "aws_s3_bucket_notification" "s3_event" {
  bucket = module.s3.bucket_name

  lambda_function {
    lambda_function_arn = module.lambda.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "lambda_errors_${module.lambda.lambda_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0

  dimensions = {
    FunctionName = module.lambda.lambda_name
  }

  alarm_description = "Alarm if Lambda function encounters any errors"
  alarm_actions     = [] # Add SNS Topic ARN if you want notifications
}


