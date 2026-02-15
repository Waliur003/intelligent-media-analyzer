# Cloud Engineering Project 04: Intelligent Media Analyzer


## Overview
I have architected and deployed an automated, AI-powered media processing pipeline on AWS. This project demonstrates the integration of Computer Vision into a serverless workflow, where images uploaded to cloud storage are automatically analyzed and indexed without any manual intervention.

## The Problem
Managing large volumes of visual data is challenging for modern enterprises. Manual tagging of images is slow, inconsistent, and expensive. Without an automated indexing system, businesses struggle to search through media libraries or extract meaningful metadata from their assets at scale.

## The Solution
- **Event-Driven Automation:** I have utilized S3 Event Notifications to trigger real-time analysis the moment a file is uploaded.
- **AI-Powered Insights:** I have integrated Amazon Rekognition to automatically detect and label objects, scenes, and concepts within images.
- **Serverless Metadata Indexing:** I have implemented a decoupled storage pattern using Amazon DynamoDB to maintain a searchable record of AI-generated tags.

## Tech Stack
- **Compute:** AWS Lambda (Python 3.12 / Boto3)  
- **Storage:** Amazon S3 (Object Storage)  
- **AI Service:** Amazon Rekognition (Computer Vision)  
- **Database:** Amazon DynamoDB (NoSQL)  
- **Security:** IAM (Least-Privilege Resource Policies)

## Project Procedure

### 1) Implemented a Scalable NoSQL Store
- I have created an Amazon DynamoDB table named **ImageAnalysisResults** to serve as the metadata repository.
- I have established **ImageID** as the Partition Key (String), ensuring that every analyzed asset is uniquely indexed and easily searchable.
- I have utilized the Default Settings to maintain a serverless, cost-effective storage model.

### 2) Developed an Intelligent Processing Layer
- I have written an AWS Lambda function in Python 3.12 named **MediaAnalysisHandler** to orchestrate the AI workflow.
- I have utilized the Boto3 SDK to extract the bucket name and object key from the incoming S3 event.
- I have integrated the Amazon Rekognition `detect_labels` API to identify objects and scenes with a minimum confidence threshold of **80%**.
- I have implemented logic to commit the generated labels and S3 metadata directly to the DynamoDB table.

### 3) Enforced Least-Privilege IAM Policies
- I have configured a dedicated IAM Execution Role for the Lambda function.
- I have implemented a custom Inline Policy that grants specific permissions for:
  - `s3:GetObject`
  - `rekognition:DetectLabels`
  - `dynamodb:PutItem`
- I have strictly defined the Resource scope to ensure the function only interacts with the necessary media and data resources, satisfying the non-negotiable security requirements for cloud infrastructure.

### 4) Configured the Media Landing Zone
- I have established a private Amazon S3 bucket named **media-analyzer-uploads-[unique-id]**.
- I have enforced **Block all public access** on the bucket to ensure that raw media remains private and is only accessible by authorized AWS service principals.

### 5) Established the Automation Trigger
- I have finalized the end-to-end automation by creating an S3 Event Notification.
- I have configured the trigger for **All object create events** (e.g., `s3:ObjectCreated:*`).
- I have successfully linked the notification to the **MediaAnalysisHandler** Lambda function, ensuring that every image upload initiates the AI analysis pipeline without manual intervention.

## Verification and Results
- **Verified the automated workflow:** I have uploaded test images (e.g., mountains, vehicles) to the S3 bucket and confirmed that the Lambda function was triggered successfully.
- **Validated the AI output:** I have reviewed the CloudWatch Logs to confirm that Amazon Rekognition returned accurate labels with high confidence.
- **Confirmed data persistence:** I have explored the DynamoDB table items and verified that the metadata and AI tags were correctly saved for each test image.

## Architecture Diagram
- Add your architecture diagram here (image or link).

## Verification Screenshots
1. **S3 Event Notification Configuration**  
   Screenshot of the S3 bucket properties showing the trigger pointing to the Lambda function.
   <img width="1919" height="910" alt="Screenshot 1" src="https://github.com/user-attachments/assets/525cd1a3-bb84-44a9-a900-8fff55253f87" />
   <img width="1919" height="910" alt="Screenshot 2" src="https://github.com/user-attachments/assets/467ff871-c878-4e6e-adc1-f943e0c6ed2c" />


2. **Intelligent Analysis Logs**  
   Screenshot of Amazon CloudWatch Logs showing the successful detection of labels from a test image.
   <img width="1919" height="909" alt="Screenshot 3" src="https://github.com/user-attachments/assets/c04a5f21-405d-444c-8de3-cd8d5102aa60" />
   <img width="1919" height="910" alt="Screenshot 4" src="https://github.com/user-attachments/assets/c033360e-b3c3-4fb4-8972-4d69929d9c43" />


4. **Least-Privilege IAM Policy**  
   Screenshot of the JSON policy showing granular permissions for S3, Rekognition, and DynamoDB.
   <img width="1919" height="911" alt="Screenshot 5" src="https://github.com/user-attachments/assets/2b0f4d46-3777-42e4-a731-9494145d3cc2" />


6. **DynamoDB Metadata Verification**  
   Screenshot of the DynamoDB table items showing the ImageID and the AI-generated label list.
   <img width="1919" height="861" alt="Screenshot 6" src="https://github.com/user-attachments/assets/e2fb67cb-39d2-4b07-9caa-5afc0ef4f80a" />


## Notes / Future Improvements
- **Web Interface:** I plan to build a simple React frontend to allow users to upload images and see the AI tags in real-time.
- **Content Moderation:** I intend to add Rekognition Content Moderation to automatically flag or blur inappropriate images upon upload.
- **Search Functionality:** I plan to implement Global Secondary Indexes (GSI) in DynamoDB to allow searching for images by specific tags (e.g., "Show me all images of cars").
