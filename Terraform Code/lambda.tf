//Create a lambda fucntion named "MediaAnalysisHandler" with the IAM role "MediaAnalysisHandlerRole" and the handler "index.handler"
resource "aws_lambda_function" "MediaAnalysisHandler" {
  function_name = "MediaAnalysisHandler"
  role          = aws_iam_role.MediaAnalysisHandlerRole.arn
  handler       = "lambda_function_payload.lambda_handler"
  runtime       = "python3.12"
  architectures = ["x86_64"]

  // specify the path to the deployment package for the lambda function
  filename      = "lambda_function_payload.zip"

  // specify the source code for the lambda function
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}