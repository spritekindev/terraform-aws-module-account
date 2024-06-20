data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Install an OIDC provider
module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "5.30.0"
}
