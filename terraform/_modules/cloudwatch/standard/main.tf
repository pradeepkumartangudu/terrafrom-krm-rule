
variable "shortname" {}
variable "environment" {}
variable "foundation" {}
variable "costcenter" {}
variable "appfamily" {}
variable "platform" {}
variable "owner" {}
variable "aws_region" {}

resource "aws_cloudwatch_log_group" "generic" {
  name = "${var.environment}-${var.platform}-${var.shortname}-${var.aws_region}"

  tags {
    name = "${var.environment}-${var.platform}-${var.shortname}-${var.aws_region}",
    foundation = "${var.foundation}",
    costcenter = "${var.costcenter}",
    appfamily = "${var.appfamily}",
    owner = "${var.owner}",
    environment = "${var.environment}"
  }
}


output "arn" {
	value="${aws_cloudwatch_log_group.generic.arn}"
}

output "name" {
	value="${var.environment}-${var.platform}-${var.shortname}-${var.aws_region}",
}