##########
#
# This is for the POC Team
#
# 

##############

variable "truncatedacctnum_att" {
  #default=${substr("${data.aws_caller_identity.current.account_id}",0,4)}
  default = "4978"
}

variable "att_appid" {
  default = "att"
}

#####
# IAM
#   

#group
resource "aws_iam_group" "att" {
  name = "g-${var.environment}-${var.platform}-att"
  path = "/foundation/${var.environment}/${var.platform}/"
}

######
# bucket
#

module "attbucket" {
  source      = "../_modules/buckets/classic_kms"
  name        = "${var.environment}-${var.platform}-att-${var.truncatedacctnum_att}-${var.aws_region}"
  environment = "${var.environment}"
  foundation  = "${var.foundation}"
  costcenter  = "adworks"
  customerid  = "adworks"
  appid       = ""
  appfamily   = "${var.appfamily}"
  platform    = "${var.platform}"
  owner       = "mf018d"
  aws_region  = "${var.aws_region}"
  kms_key_id  = "${aws_kms_key.app_att.arn}"
}

module "attbucketpolicy" {
  source          = "../_modules/bucketpolicy/kingsmountain_kms"
  s3_bucketName   = "${module.attbucket.id}"
  s3_vpc_endpoint = "${module.vpc.vpc_endpoint}"
  kms_key_id      = "${aws_kms_key.app_att.arn}"
}

### policy for service account group
resource "aws_iam_policy" "sol_svc_att-policy" {
  name        = "svc-policy-g-${var.environment}-ip-${var.att_appid}"
  path        = "/apps/${var.environment}/${var.att_appid}/"
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
                "arn:aws:s3:::${module.adipbucket.id}*"

            ]
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "sol_g_att-policy_attachment" {
  group      = "${aws_iam_group.att.name}"
  policy_arn = "${aws_iam_policy.sol_svc_att-policy.arn}"
}

############ service account
module "iam_att_appid-user" {
  source        = "../_modules/iam/user"
  iam_user_name = "svc-${var.environment}-ip-${var.att_appid}"
}

resource "aws_iam_group_membership" "att_appid-user_attachment" {
  name  = "att_appid-user_attachment"
  users = ["${module.iam_att_appid-user.iam_newuser_name}"]
  group = "${aws_iam_group.att.name}"
}

#####
# KMS
#  

resource "aws_kms_key" "app_att" {
  description             = "KMS key for bucket ${var.environment}-${var.platform}-${var.att_appid}-${var.truncatedacctnum_att}-${var.aws_region}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags {
    Name = "${var.environment}-${var.platform}-${var.att_appid}-${var.truncatedacctnum_att}-${var.aws_region}"
  }
}

resource "aws_kms_alias" "app_att" {
  name          = "alias/${var.environment}-${var.platform}-${var.att_appid}-${var.truncatedacctnum_att}-${var.aws_region}"
  target_key_id = "${aws_kms_key.app_att.key_id}"
}
