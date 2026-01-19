resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags

  force_destroy = true
}

# Lambda notification configuration
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json" # Only trigger on .json files
  }

  depends_on = [
    aws_s3_bucket.this,
  ]
}


