# This is a mock region for testing purposes only
provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

module "test" {
  source                                   = "./.."
  master_account_id                        = "dummy"
  account_name                             = "dummy"
}
