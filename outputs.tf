output "activity_logs_bucket" {
  value = aws_s3_bucket.activity_logs.bucket
  description = "The name of the S3 activity logs bucket for the account."
}

output "s3_kms_key" {
  value = aws_kms_key.s3_key
  description = "The KMS key used to encrypt the buckets for the account."
}

output "workspaces_kms_key" {
  value = aws_kms_key.workspaces
  description = "The KMS key used to encrypt the buckets for the account."
}
