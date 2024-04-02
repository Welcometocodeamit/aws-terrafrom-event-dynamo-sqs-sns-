import boto3
import csv
 
dynamodb = boto3.resource('dynamodb')
table_name = 'taskOneTable'
s3 = boto3.client('s3')
 
def handler(event, context):
    bucket_name = 'gdtc-task-one-amit'
    file_key = 'MOCK_DATA.csv'
 
    try:
        # Read CSV file from S3
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        csv_file = response['Body'].read().decode('utf-8').splitlines()
 
        # Get DynamoDB table
        table = dynamodb.Table(table_name)
 
        # Parse CSV and add data to DynamoDB table
        csv_reader = csv.reader(csv_file)
        header = next(csv_reader)  # Assuming the first row contains column headers
        for row in csv_reader:
            item = {}
            for i in range(len(header)):
                item[header[i]] = row[i]
            table.put_item(Item=item)
            
        return {
            'statusCode': 200,
            'body': 'Data added to DynamoDB successfully'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error: {str(e)}'
        }