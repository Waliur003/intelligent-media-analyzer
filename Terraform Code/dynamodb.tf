//create a dynamboDB table with terraform with billing mode as PRovisioned and read and write capacity units as 1
resource "aws_dynamodb_table" "ImageAnalysisResults" {
  name           = "ImageAnalysisResults"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ImageID"

  attribute {
    name = "ImageID"
    type = "S"
  }
}