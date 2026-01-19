

variable "table_name" {
  type        = string
  description = "DynamoDB Table Name"
}

variable "hash_key" {
  type        = string
  description = "Partition Key for DynamoDB table"
}

variable "tags" {
  type    = map(string)
  default = {}
}
