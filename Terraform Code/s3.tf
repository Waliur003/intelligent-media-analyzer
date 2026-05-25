//Create S3 bucket named "media-analyzer-uploads-waliursun003"
resource "aws_s3_bucket" "media_analyzer_uploads" {
  bucket = "media-analyzer-uploads-waliursun003"
  

  tags = {
    Name        = "Media Analyzer Uploads"
    Environment = "Production"
  }
}


//give bucket "media-analyzer-uploads-waliursun003" aws_s3_bucket_public_access_block setting all validation parameters to true
resource "aws_s3_bucket_public_access_block" "media_analyzer_uploads_public_access_block" {
  bucket = aws_s3_bucket.media_analyzer_uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Grant Amazon S3 permission to cross-invoke your Lambda Function container dynamically
resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowExecutionFromAmazonS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.MediaAnalysisHandler.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.media_analyzer_uploads.arn
}


# Establish the event-driven notification route inside your landing zone bucket
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket     = aws_s3_bucket.media_analyzer_uploads.id
  depends_on = [aws_lambda_permission.allow_s3_invocation]

  lambda_function {
    lambda_function_arn = aws_lambda_function.MediaAnalysisHandler.arn
    events              = ["s3:ObjectCreated:*"]
  }
}



  

