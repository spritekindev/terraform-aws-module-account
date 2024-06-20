#########################################################################################################
# Setup the password policy for the account
# Note that accounts don't carry user specific information and all is federated and role based
# This is in the exceptional case we need to add some user directly to the accounts.

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 12
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
  max_password_age               = 60
}
