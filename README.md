# Project 3: AWS Serverless Event Pipeline

This project implements a **serverless data pipeline** on AWS using **Terraform**.  
The pipeline automatically processes files uploaded to S3, stores data in DynamoDB, and handles errors with an SQS Dead Letter Queue (DLQ) and CloudWatch alarms.

---

## Architecture

```
S3 Bucket (Uploads)
       |
       v
   Lambda Function
       |
       v
 DynamoDB Table
       |
       +--> CloudWatch Alarms (Errors)
       |
       +--> Dead Letter Queue (SQS DLQ)
```
S3: Receives uploaded JSON files.
Lambda: Processes files and inserts records into DynamoDB.
DynamoDB: Stores processed event data.
SQS DLQ: Captures failed Lambda events.
CloudWatch: Monitors Lambda errors.
## Folder Structure
```
project3/
├─ main.tf                  # Root Terraform configuration
├─ variables.tf             # Root variables
├─ outputs.tf               # Root outputs
├─ terraform.tfvars         # Local variable values
├─ modules/
│   ├─ s3/
│   │   ├─ main.tf
│   │   ├─ variables.tf
│   │   └─ outputs.tf
│   ├─ lambda/
│   │   ├─ main.tf
│   │   ├─ variables.tf
│   │   └─ outputs.tf
│   ├─ dynamodb/
│   │   ├─ main.tf
│   │   ├─ variables.tf
│   │   └─ outputs.tf
├─ lambda/
│   └─ processor.py          # Lambda handler code
├─ sample-data/
│   └─ test.json             # Sample input file
└─ .gitignore
```
## Prerequisites
Terraform >=1.5.0
AWS CLI configured with a profile that has permissions for Lambda, S3, DynamoDB, IAM, SQS, and CloudWatch:
aws configure --profile project3
## Setup & Deployment
## 1️⃣ Initialize Terraform
```
terraform init
```
## 2️⃣ Plan the infrastructure
```
terraform plan -var-file="terraform.tfvars"
```
## 3️⃣ Apply the infrastructure
```
terraform apply -var-file="terraform.tfvars"
```
This creates S3 bucket, Lambda function, DynamoDB table, SQS DLQ, and CloudWatch alarms.
## Testing the Pipeline
Upload a sample JSON file to the S3 bucket:
```
aws s3 cp sample-data/test.json s3://<your-bucket-name>/
```
Check Lambda logs in CloudWatch:
```
aws logs get-log-events \
  --log-group-name "/aws/lambda/process_uploaded_file" \
  --log-stream-name <LATEST_STREAM_NAME>
```
Verify DynamoDB contains the inserted items.
## Destroying Infrastructure
```
terraform destroy -var-file="terraform.tfvars"
```
Note: If the S3 bucket is not empty, Terraform will fail. Use force_destroy = true in the bucket resource to automatically delete all objects.
## Terraform Best Practices
Use modules for reusable resources (S3, Lambda, DynamoDB).
Keep Terraform state out of Git using .gitignore.
Use variables and terraform.tfvars for environment-specific configurations.
Use outputs to reference important ARNs and resource names.
Use terraform validate before apply to catch errors early.
## Environment Variables for Lambda
TABLE_NAME → DynamoDB table name
## Sample JSON File
s3/sample-data/test.json:
```
{
  "source": "manual-upload-test",
  "uploaded_by": "terraform-project-3",
  "records": [
    {
      "event_id": "evt-001",
      "type": "user_signup",
      "timestamp": "2026-01-16T18:30:00Z"
    },
    {
      "event_id": "evt-002",
      "type": "file_upload",
      "timestamp": "2026-01-16T18:31:00Z"
    }
  ]
}
```
## Outputs
lambda_name → Name of the Lambda function
lambda_arn → ARN of the Lambda function
s3_bucket_name → Name of S3 bucket
dynamodb_table_name → Name of DynamoDB table
sqs_dlq_arn → ARN of SQS DLQ
## Notes
Make sure Lambda ZIP file (processor.zip) is non-empty.
Lambda IAM role must have permissions: s3:GetObject, dynamodb:PutItem, sqs:SendMessage, logs:*.
Clean up resources to avoid AWS charges.

