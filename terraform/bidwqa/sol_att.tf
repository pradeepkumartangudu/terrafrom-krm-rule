##########
#
# This is for the POC Team
#
# 

##############

variable "truncatedacctnum_att" {
  #default=${substr("${data.aws_caller_identity.current.account_id}",0,4)}
  default = "3935"
}

variable "appid" {
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

#####
# KMS
#  

resource "aws_kms_key" "app_att" {
  description             = "KMS key for bucket ${var.environment}-${var.platform}-${var.appid}-${var.truncatedacctnum_att}-${var.aws_region}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags {
    Name = "${var.environment}-${var.platform}-${var.appid}-${var.truncatedacctnum_att}-${var.aws_region}"
  }
}

resource "aws_kms_alias" "app_att" {
  name          = "alias/${var.environment}-${var.platform}-${var.appid}-${var.truncatedacctnum_att}-${var.aws_region}"
  target_key_id = "${aws_kms_key.app_att.key_id}"
}
