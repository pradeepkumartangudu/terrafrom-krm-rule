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
    bucket = "dv-mac-platformconfig-us-east-1"
    key    = "runtime/terraform.tfstate"
    region = "us-east-1"
	encrypt = true

  }
}