terraform {
  backend "s3" {
    bucket         = "terraform-state-project3"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
