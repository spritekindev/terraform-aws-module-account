#########################################################################################################
# Each account should have a bucket specific for logs
# Object access log is same account only
resource "aws_s3_bucket" "activity_logs" {
  bucket = "${var.organisation}-${var.account_name}-activity-logs"
  force_destroy = var.destroy_logs_with_account
  tags   = {
    account = "${var.account_name}"
  }
}

resource "aws_s3_bucket_ownership_controls" "activity_logs" {
  bucket = aws_s3_bucket.activity_logs.id
  rule {
    object_ownership         = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "activity_logs" {
  bucket = aws_s3_bucket.activity_logs.id
  acl    = "log-delivery-write"
  depends_on = [aws_s3_bucket_ownership_controls.activity_logs]
}

resource "aws_s3_bucket_versioning" "activity_logs" {
  bucket = aws_s3_bucket.activity_logs.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# AWS now encrypts objects at rest by default
#resource "aws_s3_bucket_server_side_encryption_configuration" "activity_logs" {
#  bucket = aws_s3_bucket.activity_logs.bucket
#  rule {
#    apply_server_side_encryption_by_default {
#      sse_algorithm     = "AES256"
#    }
#    bucket_key_enabled = true
#  }
#}
