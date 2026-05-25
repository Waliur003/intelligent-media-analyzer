//Define the Trust Policy allowing AWS Lambda to assume this execution role
data "aws_iam_policy_document" "aws_iam_lambda_assume_role_policy" {
    statement {
        effect = "Allow"
        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

// attach the above policy named"MediaAnalysisHandlerPolicy" document with an IAM role named "MediaAnalysisHandlerRole" 
resource "aws_iam_role" "MediaAnalysisHandlerRole" {
    name = "MediaAnalysisHandlerRole"
    assume_role_policy = data.aws_iam_policy_document.MediaAnalysisHandlerPolicy.json
  
}


//Create IAM policy document to Formulate Least-Privilege Identity Foundations named "MediaAnalysisHandlerPolicy"
data "aws_iam_policy_document" "MediaAnalysisHandlerPolicy" {
    statement {
        sid    = "IsolatedS3ObjectIngestionAccess"
        effect = "Allow"
        actions = [
            "s3:GetObject"
        ]
        resources = ["arn:aws:s3:::media-analyzer-uploads-*/*"]
    }
    statement {
        sid    = "ServerlessComputerVisionInvocations"
        effect = "Allow"
        actions = [
            "rekognition:DetectLabels"
        ]
        resources = ["*"]
    }
    statement {
        sid    = "TargetedDynamoDBTableWriteAccess"
        effect = "Allow"
        actions = [
            "dynamodb:PutItem"
        ]
        resources = ["arn:aws:dynamodb:*:*:table/ImageAnalysisResults"]
    }
    statement {
        sid    = "StructuredCloudWatchLogging"
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = ["arn:aws:logs:*:*:*"]
    }
}

//Generate the managed IAM Policy resource from the data document
resource "aws_iam_policy" "MediaAnalysisHandlerPolicy" {
    name        = "MediaAnalysisHandlerPolicy"
    description = "IAM policy for Media Analysis Handler Lambda function with least-privilege permissions."
    policy      = data.aws_iam_policy_document.MediaAnalysisHandlerPolicy.json
}

//Bind the policy directly to the active Lambda execution role
resource "aws_iam_role_policy_attachment" "MediaAnalysisHandlerRolePolicyAttachment" {
    role       = aws_iam_role.MediaAnalysisHandlerRole.name
    policy_arn = aws_iam_policy.MediaAnalysisHandlerPolicy.arn
}




