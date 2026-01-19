variable "function_name" { type = string }
variable "handler" { type = string }
variable "runtime" { type = string }
variable "filename" { type = string }
variable "environment" { type = map(string) }
variable "tags" { type = map(string) }
variable "dlq_arn" {
  type        = string
  description = "ARN of the SQS Dead Letter Queue for Lambda"
  default     = ""
}

