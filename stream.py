import json
import boto3
import os

sqs = boto3.client('sqs')

def lambda_handler(event, context):
    sqs_queue_url = os.environ['SQS_QUEUE_URL']
    print(sqs_queue_url)
    for record in event['Records']:
        # Extract the new image from the DynamoDB stream record
        new_image = record.get('dynamodb', {}).get('NewImage', {})
        
        # Convert the new image to JSON
        message_body = json.dumps(new_image)
        
        # Send the message to the SQS queue
        sqs.send_message(
            QueueUrl=sqs_queue_url,  # Replace SQS_QUEUE_URL with your SQS queue URL
            MessageBody=message_body
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Messages forwarded to SQS successfully')
    }
