import json
import os
import boto3
 
def handler(event, context):
    sns_client = boto3.client('sns')
    for record in event['Records']:
        message_body = record['body']
        dynamodb_data = message_body
        sns_message = f"Data added to DynamoDB: {json.dumps(dynamodb_data)}"
        sns_subject = "DynamoDB Data Added"
        sns_topic_arn = os.environ['SNS_TOPIC_ARN']
        sns_client.publish(
            TopicArn = sns_topic_arn,
            Message = sns_message,
            Subject = sns_subject
        )
    return {
        'statusCode': 200,
        'body': json.dumps('SNS message sent successfully')
    }