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
    bucket     = "qa-mac-platformconfig-us-east-1"
    key        = "runtime/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
    kms_key_id = "arn:aws:kms:us-east-1:393566551251:key/dc95d8f4-c386-49bd-bd69-305bc353bd86"
  }
}
