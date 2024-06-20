##############################################################################################################
# Enable GuardDuty
# Not available for now
##################################################################################################################
# Create a guardduty key and grant usage to Guardduty

## Grant the guardduty detector access to the key
#data "aws_iam_policy_document" "guardduty_detector_kms" {
#
#  statement {
#    sid = "Enable IAM User Permissions"
#    effect = "Allow"
#    actions = [
#      "kms:*"
#    ]
#    resources = [
#      "*"
#    ]
#    principals {
#      type        = "AWS"
#      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#    }
#  }
#
#  statement {
#    sid = "Allow GuardDuty to encrypt findings"
#    effect = "Allow"
#    actions = [
#      "kms:GenerateDataKey",
#      "kms:ListAliases"
#    ]
#
#    resources = [
#      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
#    ]
#
#    principals {
#      type        = "Service"
#      identifiers = ["guardduty.amazonaws.com"]
#    }
#  }
#}
#
#resource "aws_kms_key" "guardduty" {
#  description             = "This key is used to encrypt guardduty objects"
#  deletion_window_in_days = 30
#  policy                  = data.aws_iam_policy_document.guardduty_detector_kms.json
#}
#
#resource "aws_kms_alias" "guardduty" {
#  name          = "alias/guardduty"
#  target_key_id = aws_kms_key.guardduty.key_id
#}
#
#module "guardduty" {
#  source  = "cloudposse/guardduty/aws"
#  version = "0.5.0"
#  environment = var.account_name
#  finding_publishing_frequency = "ONE_HOUR"
#  label_order = ["environment"]
#
#  enable_cloudwatch = true
#  s3_protection_enabled = true
#  create_sns_topic = true
#  subscribers = {
#    spritekin_admin = {
#      protocol = "email"
#      endpoint = "admin@spritekin.com"
#      endpoint_auto_confirms = false
#      raw_message_delivery = false
#    }
#  }
#}
#
#resource "aws_guardduty_publishing_destination" "guardduty_destination" {
#  detector_id     = module.guardduty.guardduty_detector.id
#  destination_arn = var.guardduty_bucket_arn
#  kms_key_arn     = aws_kms_key.guardduty.arn
#}
