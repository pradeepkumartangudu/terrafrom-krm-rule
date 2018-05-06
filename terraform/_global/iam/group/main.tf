#
# Global Group Definitions
#

#### Variables

variable "environment" {}
variable "platform" {}

#### Definitions 
#
#  

#resource "aws_iam_group" "superadmins" {
#  name = "u-${var.environment}-${var.platform}-superadmins"
#  path = "/foundation/${var.environment}/${var.platform}/"
#}

resource "aws_iam_group" "platformadmins" {
  name = "u-${var.environment}-${var.platform}-platformadmins"
  path = "/foundation/${var.environment}/${var.platform}/"
}

output "group_platform_admins_name" {
  value = "${aws_iam_group.platformadmins.name}"
}

########## this is just for terraform really without roles
resource "aws_iam_group" "platformautomation" {
  name = "g-${var.environment}-${var.platform}-platformautomation"
  path = "/foundation/${var.environment}/${var.platform}/"
}

output "group_platform_automation_name" {
  value = "${aws_iam_group.platformautomation.name}"
}

#resource "aws_iam_group" "powerusers" {
#  name = "u-${var.environment}-${var.platform}-powerusers"
#  path = "/foundation/${var.environment}/${var.platform}/"
#}

resource "aws_iam_group" "auditors" {
  name = "u-${var.environment}-${var.platform}-auditors"
  path = "/foundation/${var.environment}/${var.platform}/"
}

#resource "aws_iam_group" "kingsmountains3browswersvc" {
#  name = "g-${var.environment}-${var.platform}-s3CloudRouter"
#  path = "/foundation/${var.environment}/${var.platform}//"
#}

#resource "aws_iam_group" "kingsmountains3browswer" {
#  name = "u-${var.environment}-${var.platform}-S3user"
#  path = "/foundation/${var.environment}/${var.platform}/"
#}

resource "aws_iam_group" "billing" {
  name = "u-${var.environment}-${var.platform}-billing"
  path = "/foundation/${var.environment}/${var.platform}/"
}

resource "aws_iam_policy_attachment" "billing" {
  name       = "billing"
  groups     = ["${aws_iam_group.billing.name}"]
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}
