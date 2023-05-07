import json
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("VisitorCounter")

    response = table.get_item(Key={"id": "visitor_count"})
    count = int(response["Item"]["count"])

    table.update_item(
        Key={"id": "visitor_count"},
        UpdateExpression="SET #count = :count",
        ExpressionAttributeNames={"#count": "count"},
        ExpressionAttributeValues={":count": count + 1}
    )

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Methods": "GET"
        },
        "body": json.dumps({"count": count + 1})
    }
