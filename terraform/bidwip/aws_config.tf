######
# Connecting with AWS
#

#####
# Provider
#
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

######
# Backend
# This can't have interpolations which kinda sucks
terraform {
  backend "s3" {
    bucket     = "pr-ip-platformconfig-us-east-1"
    key        = "runtime/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
    kms_key_id = "arn:aws:kms:us-east-1:497834522136:key/1981a346-3827-4666-93ee-0bfcd5fffa7a"
  }
}
