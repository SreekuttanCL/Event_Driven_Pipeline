variable "bucket_name" {
  type        = string
  description = "Name of S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the bucket"
  default     = {}
}

variable "lambda_arn" {
  type        = string
  description = "ARN of the Lambda function to invoke on object creation"
}
