##########
#
# This is for the ip bucket for ADIP
#
# 

##############

variable "truncatedacctnum_adip" {
  #default=${substr("${data.aws_caller_identity.current.account_id}",0,4)}
  default = "3935"
}

variable "ip_platform" {
  default = "ip"
}

variable "adip_appid" {
  default = "adip"
}

#####
# BUCKETS
#

module "adipbucket" {
  source = "../_modules/buckets/classic_kms"

  name        = "${var.environment}-${var.ip_platform}-${var.adip_appid}-${var.truncatedacctnum_adip}-${var.aws_region}"
  environment = "${var.environment}"
  foundation  = "${var.foundation}"
  costcenter  = "adworks"
  customerid  = "adworks"
  appid       = "ddl-programmer"
  appfamily   = "${var.ip_platform}"
  platform    = "${var.ip_platform}"
  owner       = "mf018d"
  aws_region  = "${var.aws_region}"
  kms_key_id  = "arn:aws:kms:us-east-1:393566551251:key/ba5b10f2-792d-40da-925a-42a2083ed008"
}

module "adipbucketpolicy" {
  source               = "../_modules/bucketpolicy/external_accounts/adip"
  s3_bucketName        = "${module.adipbucket.id}"
  vpc-identifier       = "${module.vpc.vpc_id}"
  remote_vpc_endpoint  = "vpce-49c75220"
  remote_vpc_endpoint2 = "${module.vpc.vpc_endpoint}"
  remote_principal     = "280723139509:root"
  kms_key_id           = "arn:aws:kms:us-east-1:393566551251:key/ba5b10f2-792d-40da-925a-42a2083ed008"
}

#####
# IAM
#   

#service account group
resource "aws_iam_group" "svc_aid" {
  name = "g-${var.environment}-${var.ip_platform}-${var.adip_appid}"
  path = "/apps/${var.environment}/${var.adip_appid}/"
}

### policy for service account group
resource "aws_iam_policy" "sol_svc_aid-policy" {
  name        = "svc-policy-g-${var.environment}-${var.ip_platform}-${var.adip_appid}"
  path        = "/apps/${var.environment}/${var.adip_appid}/"
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

resource "aws_iam_group_policy_attachment" "sol_g_aid-policy_attachment" {
  group      = "${aws_iam_group.svc_aid.name}"
  policy_arn = "${aws_iam_policy.sol_svc_aid-policy.arn}"
}

##### user group
resource "aws_iam_group" "u_aid" {
  name = "u-${var.environment}-${var.ip_platform}-${var.adip_appid}"
  path = "/apps/${var.environment}/${var.adip_appid}/"
}

##### user group policy
resource "aws_iam_policy" "sol_u_aid-policy" {
  name        = "u-policy-u-${var.environment}-${var.ip_platform}-${var.adip_appid}"
  path        = "/apps/${var.environment}/${var.adip_appid}/"
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
                "arn:aws:s3:::${module.adipbucket.id}*"

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
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "sol_u_aid-policy_attachment" {
  group      = "${aws_iam_group.u_aid.name}"
  policy_arn = "${aws_iam_policy.sol_u_aid-policy.arn}"
}

############ service account
module "iam_adip_appid-user" {
  source        = "../_modules/iam/user"
  iam_user_name = "svc-${var.environment}-${var.ip_platform}-${var.adip_appid}"
}

resource "aws_iam_group_membership" "adip_appid-user_attachment" {
  name  = "adip_appid-user_attachment"
  users = ["${module.iam_adip_appid-user.iam_newuser_name}"]
  group = "${aws_iam_group.svc_aid.name}"
}
