# Master account ID
variable "master_account_id" {
  type = string
  default = ""
  description = "The master account id from which users will asume roles into this account."
}

variable "organisation" {
  type = string
  default = "humanforce"
  description = "The organisation name"
}

variable "account_name" {
  type = string
  description = "The account name"
}

variable "cloudtrail_bucket" {
  type = string
  default = ""
  description = "Bucket where to place the activity trails. If empty cloudtrails won't be initialised"
}

variable "guardduty_bucket" {
  type = string
  default = ""
  description = "Bucket ARN where to place the guardduty reports. If empty guardduty won't be initialised"
}

variable "destroy_logs_with_account" {
  type = bool
  default = "true"
  description = "If true, the logs buckets and contents will be destroyed with the account. If false it will raise an error."
}

variable "service_linked_role" {
  type = map(string)
  default = {}
  description = "Services to create a service-linked-role against"
}

variable "max_session_duration" {
  type = number
  default = 3600
  description = "Duration of role sessions"
}

variable "super_admin_trusted_roles" {
  type = list(string)
  default = []
  description = "Roles allowed to assume super admin role"  
}

variable "admin_trusted_roles" {
  type = list(string)
  default = []
  description = "Roles allowed to assume admin role"  
}

variable "readonly_trusted_roles" {
  type = list(string)
  default = []
  description = "Roles allowed to assume readonly role"  
}

variable "create_s3_kms_key" {
  type = bool
  default = "false"
  description = "If true, create a KMS key with alias 'alias/s3-<account_name>' (i.e. alias/s3-master)."
}

variable "create_workspaces_kms_key" {
  type = bool
  default = "false"
  description = "If true, create a KMS key with alias 'alias/workspaces-<account_name>' (i.e. alias/workspaces-master)."
}

