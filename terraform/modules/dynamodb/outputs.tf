output "table_name" {
  value       = aws_dynamodb_table.this.name
  description = "The name of the DynamoDB table"
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.this.arn
}
