# Simple S3 bucket
resource "aws_s3_bucket" "simple_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name        = "${var.name_prefix}-s3-bucket"
    Environment = var.environment
    Purpose     = "General Purpose S3 Bucket"
  }
}
