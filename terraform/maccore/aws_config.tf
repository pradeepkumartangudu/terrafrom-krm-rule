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
    bucket     = "mc-mac-platformconfig-us-east-1"
    key        = "runtime/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
    kms_key_id = "arn:aws:kms:us-east-1:695019450051:key/24a9988d-8084-4a85-b53b-f4d0af1ccd6a"
  }
}
