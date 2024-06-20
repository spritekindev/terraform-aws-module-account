# Cotton Candy Cloud Account Module #

Initialise your AWS account to make it compatible with CCC.

### What it does ###
Initialises cloudtrail if a target bucket is provided.
Initialises guardduty if a target bucket is provided.
Creates an S3 log bucket, this is intended for multiple logging uses like:
 - S3 file changes.
 - LoadBalancer monitoring including WAF
 - Application logs
Optional creation of KMS keys for:
 - S3 encryption
 - AWS Workspaces
Roles for:
 - Admin
 - Poweruser
 - Readonly
 - Github Actions OIDC
 - SNS Notifications

Service linked roles


## Notes ##
The buckets for cloudtrail and guardduty should be created outside of the module.
This is intentional as it is expected the bucket is located in some secured account
and is used by multiple accounts. It may also happen those services are managed
in an organisation level in which case this is completely unnecessary.
