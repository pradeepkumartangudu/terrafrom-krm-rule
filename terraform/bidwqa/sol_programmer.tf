##########
#
# This is for the POC Team
#
# 

##############

variable "truncatedacctnum_pgr" {
  #default=${substr("${data.aws_caller_identity.current.account_id}",0,4)}
  default = "3935"
}

#####
# IAM
#   

#group
resource "aws_iam_group" "programmer" {
  name = "u-${var.environment}-${var.platform}-programmer"
  path = "/foundation/${var.environment}/${var.platform}/"
}

######
# bucket
#

module "programmerbucket" {
  source      = "../_modules/buckets/classic_kms"
  name        = "${var.environment}-${var.platform}-programmer-${var.truncatedacctnum_pgr}-${var.aws_region}"
  environment = "${var.environment}"
  foundation  = "${var.foundation}"
  costcenter  = "adworks"
  customerid  = "adworks"
  appid       = "ddl-programmer"
  appfamily   = "${var.appfamily}"
  platform    = "${var.platform}"
  owner       = "${var.owner}"
  aws_region  = "${var.aws_region}"
  kms_key_id  = "${aws_kms_key.app_pgr.arn}"
}

module "programmerbucketpolicy" {
  source          = "../_modules/bucketpolicy/kingsmountain_kms"
  s3_bucketName   = "${module.programmerbucket.id}"
  s3_vpc_endpoint = "${module.vpc.vpc_endpoint}"
  kms_key_id      = "${aws_kms_key.app_pgr.arn}"
}

#####
# KMS
#  

resource "aws_kms_key" "app_pgr" {
  description             = "KMS key for bucket ${var.environment}-${var.platform}-programmer-${var.truncatedacctnum_pgr}-${var.aws_region}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags {
    Name = "${var.environment}-${var.platform}-programmer-${var.truncatedacctnum_pgr}-${var.aws_region}"
  }
}

resource "aws_kms_alias" "app_pgr" {
  name          = "alias/${var.environment}-${var.platform}-programmer-${var.truncatedacctnum_pgr}-${var.aws_region}"
  target_key_id = "${aws_kms_key.app_pgr.key_id}"
}
