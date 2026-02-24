import boto3
import json

rekognition = boto3.client('rekognition')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ImageAnalysisResults')

def lambda_handler(event, context):
    # Retrieve bucket and file names from the event trigger
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    try:
        # Request Amazon Rekognition to identify objects in the image
        response = rekognition.detect_labels(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}},
            MaxLabels=10,
            MinConfidence=80
        )
        
        # Format the detected tags into a list
        labels = [label['Name'] for label in response['Labels']]
        
        # Save the metadata and AI tags into DynamoDB
        table.put_item(Item={
            'ImageID': key,
            'Labels': labels,
            'Bucket': bucket
        })
        
        return {"status": "Success", "tags_found": labels}
    except Exception as e:
        print(f"Error during analysis: {str(e)}")
        return {"status": "Error", "message": str(e)}
