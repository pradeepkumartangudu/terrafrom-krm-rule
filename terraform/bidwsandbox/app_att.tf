##############
# Generic Application with KMS
# 
# Set the variable block below as per your application
##############

variable "appid" {
  default = "att"
}

variable "app_owner" {
  default = "mf018d"
}

variable "app_customerid" {
  default = "adworks"
}

variable "app_costcenter" {
  default = "adworks"
}

######
# Bucket
#

module "attbucket" {
  source      = "../_modules/buckets/classic_kms"
  name        = "${var.environment}-${var.platform}-${var.appid}-${var.truncatedacctnum}-${var.aws_region}"
  environment = "${var.environment}"
  foundation  = "${var.foundation}"
  costcenter  = "${var.app_costcenter}"
  customerid  = "${var.app_customerid}"
  appid       = "${var.appid}"
  appfamily   = "${var.appfamily}"
  platform    = "${var.platform}"
  owner       = "${var.app_owner}"
  aws_region  = "${var.aws_region}"
  kms_key_id  = "${aws_kms_key.app_att.arn}"
}

module "attbucketpolicy" {
  source          = "../_modules/bucketpolicy/kingsmountain_kms"
  s3_bucketName   = "${module.attbucket.id}"
  s3_vpc_endpoint = "${module.vpc.vpc_endpoint}"
  kms_key_id      = "${aws_kms_key.app_att.arn}"
}

#####
# IAM
#   

#service account group
resource "aws_iam_group" "svc_att" {
  name = "g-${var.environment}-${var.platform}-${var.appid}"
  path = "/foundation/${var.environment}/${var.platform}/"
}

### policy for service account group
resource "aws_iam_policy" "sol_svc_att-policy" {
  name        = "svc-policy-g-${var.environment}-${var.platform}-${var.appid}"
  path        = "/apps/${var.environment}/${var.appid}/"
  description = "bucket access policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1512410953000",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:Put*",
                "s3:Delete*",
                "s3:List*",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${module.attbucket.id}*"

            ]
        },
        {
          "Sid": "AllowEncryptDecrypt",
          "Effect": "Allow",
          "Action": [
            "kms:Encrypt",
            "kms:Decrypt"
          ],
          "Resource": [
            "${aws_kms_key.app_att.arn}"
          ]
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "sol_g_att-policy_attachment" {
  group      = "${aws_iam_group.svc_att.name}"
  policy_arn = "${aws_iam_policy.sol_svc_att-policy.arn}"
}

##### user group
resource "aws_iam_group" "u_att" {
  name = "u-${var.environment}-${var.platform}-${var.appid}"
  path = "/apps/${var.environment}/${var.appid}/"
}

##### user group policy
resource "aws_iam_policy" "sol_u_att-policy" {
  name        = "u-policy-u-${var.environment}-${var.platform}-${var.appid}"
  path        = "/apps/${var.environment}/${var.appid}/"
  description = "bucket acces policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1512410953000",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::${module.attbucket.id}*"

            ]
        },
        {
            "Sid": "listingbuckets",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
          "Sid": "AllowEncryptDecrypt",
          "Effect": "Allow",
          "Action": [
            "kms:Encrypt",
            "kms:Decrypt"
          ],
          "Resource": [
            "${aws_kms_key.app_att.arn}"
          ]
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "sol_u_att-policy_attachment" {
  group      = "${aws_iam_group.u_att.name}"
  policy_arn = "${aws_iam_policy.sol_u_att-policy.arn}"
}

############ service account
module "iam_att_appid-user" {
  source        = "../_modules/iam/user"
  iam_user_name = "svc-${var.environment}-${var.platform}-${var.appid}"
}

resource "aws_iam_group_membership" "att_appid-user_attachment" {
  name  = "att_appid-user_attachment"
  users = ["${module.iam_att_appid-user.iam_newuser_name}"]
  group = "${aws_iam_group.svc_att.name}"
}

#####
# KMS
#  

resource "aws_kms_key" "app_att" {
  description             = "KMS key for bucket ${var.environment}-${var.platform}-${var.appid}-${var.truncatedacctnum}-${var.aws_region}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags {
    Name = "${var.environment}-${var.platform}-${var.appid}-${var.truncatedacctnum}-${var.aws_region}"
  }
}

resource "aws_kms_alias" "app_att" {
  name          = "alias/${var.environment}-${var.platform}-${var.appid}-${var.truncatedacctnum}-${var.aws_region}"
  target_key_id = "${aws_kms_key.app_att.key_id}"
}
