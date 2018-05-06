##########
#
# This is for the POC Team
#
# 

##############

variable "truncatedacctnum_att" {
  #default=${substr("${data.aws_caller_identity.current.account_id}",0,4)}
  default = "5478"
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
  kms_key_id  = "arn:aws:kms:us-east-1:547895166865:key/15d49ea7-092d-4fe0-824d-4498ae280a2e"
}

module "attbucketpolicy" {
  source          = "../_modules/bucketpolicy/kingsmountain_kms"
  s3_bucketName   = "${module.attbucket.id}"
  s3_vpc_endpoint = "${module.vpc.vpc_endpoint}"
  kms_key_id      = "arn:aws:kms:us-east-1:547895166865:key/15d49ea7-092d-4fe0-824d-4498ae280a2e"
}
