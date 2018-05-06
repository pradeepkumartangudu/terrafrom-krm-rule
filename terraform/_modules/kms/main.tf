#
# KMS
#

####
# Variables
#

variable "environment" {}
variable "costcenter" {}
variable "platform" {}



####
# Resource Definitions
#
resource "aws_kms_key" "defaultatl" {
  description             = "Default alternative Key for the account in this region"
  deletion_window_in_days = 10
  enable_key_rotation = true
  tags {
    environment = "${var.environment}",
    foundation = "true",
    costcenter = "${var.costcenter}",
    appfamily = "${var.platform}"

  }
}



resource "aws_kms_alias" "defaultatl" {
  name = "alias/${var.environment}-${var.platform}-default"
 target_key_id = "${aws_kms_key.defaultatl.key_id}"
  
}


##
resource "aws_kms_key" "defaultemrkey" {
  description             = "Default emr key in this region"
  deletion_window_in_days = 10
  enable_key_rotation = true
  tags {
    environment = "${var.environment}",
    foundation = "true",
    costcenter = "${var.costcenter}",
    appfamily = "${var.platform}"

  }
}



resource "aws_kms_alias" "defaultemrkey" {
  name = "alias/${var.environment}-${var.platform}-defaultemr"
  target_key_id = "${aws_kms_key.defaultemrkey.key_id}"
}