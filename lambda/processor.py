import json
import boto3
import os
import uuid

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    print("LAMBDA STARTED")
    print("EVENT:", json.dumps(event))

    if "Records" in event:
        for record in event["Records"]:
            if "s3" in record:
                file_name = record["s3"]["object"]["key"]

                item = {
                    "id": str(uuid.uuid4()),
                    "file_name": file_name
                }

                table.put_item(Item=item)
                print("Inserted item:", item)

    return {"status": "success"}
