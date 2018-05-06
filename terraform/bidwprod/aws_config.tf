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
    bucket     = "pr-mac-platformconfig-us-east-1"
    key        = "runtime/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
    kms_key_id = "arn:aws:kms:us-east-1:547895166865:key/e3beb3fa-292e-4615-b11c-df00e293bbd4"
  }
}
