############################################################################################
# Account admin role, grants full admin privileges to the

locals {
  super_admin_trusted_roles = distinct(concat(["arn:aws:iam::${var.master_account_id}:root"], var.super_admin_trusted_roles))
  super_admin_trusted_roles_string = join(", ", [for role in local.super_admin_trusted_roles : format("%q", role)])

  admin_trusted_roles = distinct(concat(["arn:aws:iam::${var.master_account_id}:root"], var.admin_trusted_roles))
  admin_trusted_roles_string = join(", ", [for role in local.admin_trusted_roles : format("%q", role)])

  readonly_trusted_roles = distinct(concat(["arn:aws:iam::${var.master_account_id}:root"], var.readonly_trusted_roles))
  readonly_trusted_roles_string = join(", ", [for role in local.readonly_trusted_roles : format("%q", role)])
}


resource "aws_iam_policy" "super_admin_policy" {
  name = "${var.account_name}-super-admin-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "super_admin" {
  name = "${var.account_name}-super-admin"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "AWS": [${local.super_admin_trusted_roles_string}]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
  max_session_duration = var.max_session_duration
  managed_policy_arns = [aws_iam_policy.super_admin_policy.arn]

  tags = {
    tag-key = "${var.account_name}-super-admin"
  }

}

# To be filled later
output "super_admin_role" {
  value = aws_iam_role.super_admin
  description = "The super admin role."
}

############################################################################################
# Admin/Power user role, grants power privileges to the user but no IAM change access

data "aws_iam_policy" "PowerUserAccess" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role" "admin" {
  name = "${var.account_name}-admin"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "AWS": [${local.admin_trusted_roles_string}]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
  max_session_duration = var.max_session_duration
  managed_policy_arns = [data.aws_iam_policy.PowerUserAccess.arn]

  tags = {
    tag-key = "${var.account_name}-admin"
  }

}

output "admin_role" {
  value = aws_iam_role.admin
  description = "The admin role."
}

############################################################################################
# Readonly role, grants readonly access

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role" "readonly" {
  name = "${var.account_name}-readonly"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "AWS": [${local.readonly_trusted_roles_string}]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
  max_session_duration = var.max_session_duration
  managed_policy_arns = [data.aws_iam_policy.PowerUserAccess.arn]

  tags = {
    tag-key = "${var.account_name}-readonly"
  }

}

output "readonly_role" {
  value = aws_iam_role.readonly
  description = "The readonly role."
}



############################################################################################
# GitHub Actions role, needs almost full access to support deploying CFN stacks etc

resource "aws_iam_role" "github_actions" {
  name               = "GitHubActionsOIDCRole"
  assume_role_policy = data.aws_iam_policy_document.github_actions_oidc.json
  max_session_duration = 7200
}

data "aws_iam_policy_document" "github_actions_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.iam_github_oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.iam_github_oidc_provider.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${module.iam_github_oidc_provider.url}:sub"
      values   = ["repo:humanforce/*"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "github_actions_full_access" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


output "githubactions_role" {
  value = aws_iam_role.github_actions
  description = "The GitHub Actions role."
}

resource "aws_iam_role" "sns_delivery_notifications_role" {
  name                  = "SNSDeliveryNotificationsRole"
  description           = "Allows SNS to log delivery notifications to CloudWatch Logs"
  assume_role_policy    = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [aws_iam_policy.sns_delivery_notifications_policy.arn]

}
resource "aws_iam_policy" "sns_delivery_notifications_policy" {
  name = "${var.account_name}-sns-delivery-notifications-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutMetricFilter",
          "logs:PutRetentionPolicy"
        ],
        Resource = "*"
      }
    ]
  })
}
