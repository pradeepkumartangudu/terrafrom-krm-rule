###########################################################
#  _module\iam\user\ - main.tf
#
#  create a user

variable "iam_user_name" {}

resource "aws_iam_user" "genericuserwkeys" {
  name = "${var.iam_user_name}"
  path = "/user/"
}

resource "aws_iam_access_key" "genericuserkey" {
  user    = "${aws_iam_user.genericuserwkeys.name}"
}

#####
output "iam_newuser_arn" {
value="${aws_iam_user.genericuserwkeys.arn}"
}

output "iam_newuser_name" {
value="${aws_iam_user.genericuserwkeys.name}"
}

output "iam_newuser_uid" {
value="${aws_iam_user.genericuserwkeys.unique_id}"
}

output "iam_newuser_accesskey" {
value="${aws_iam_access_key.genericuserkey.id}"
}

output "iam_newuser_secretkey" {
value="${aws_iam_access_key.genericuserkey.secret}"
}