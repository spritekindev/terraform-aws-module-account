# Setup CloudTrail in each account
# Enable Cloudtrail for all regions of the account. The target bucket is specified as a module parameter
# If the bucket is not specified, ignore
resource "aws_cloudtrail" "cloudtrail" {
  count = var.cloudtrail_bucket == "" ? 0 : 1
  name                          = "${var.organisation}-${var.account_name}-cloudtrail"
  s3_bucket_name                = var.cloudtrail_bucket
  include_global_service_events = true
  is_multi_region_trail         = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}
