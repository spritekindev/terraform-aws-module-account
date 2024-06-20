##################################################################################################################
# Creates specific keys in case we would like to bypass the default AWS provided KMS keys
##################################################################################################################

##################################################################################################################
# Create an encryption key for bucket objects
resource "aws_kms_key" "s3_key" {
  count                   = var.create_s3_kms_key ? 1 : 0
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "s3_key" {
  count         = var.create_s3_kms_key ? 1 : 0
  name          = "alias/s3-${var.account_name}"
  target_key_id = aws_kms_key.s3_key[0].key_id
}

# Create an encryption key for AWS Workspaces

data "aws_iam_policy_document" "workspaces_kms" {
  statement {
    sid = "Enable IAM User Permissions"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_kms_key" "workspaces" {
  count                   = var.create_workspaces_kms_key ? 1 : 0
  description             = "This key is used to encrypt AWS workspaces"
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.workspaces_kms.json
}

resource "aws_kms_alias" "workspaces" {
  count         = var.create_workspaces_kms_key ? 1 : 0
  name          = "alias/workspaces-${var.account_name}"
  target_key_id = aws_kms_key.workspaces[0].key_id
}
