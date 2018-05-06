###########################################################
#  _module\iam\user\ - main.tf
#
#  create a user

variable "iam_user_name" {}

resource "aws_iam_user" "genericuser" {
  name = "${var.iam_user_name}"
  path = "/user/"
}

#resource "aws_iam_access_key" "genricuserkey" {
#  user    = "${aws_iam_user.genericuser.name}"
#}

#####
output "iam_newuser_arn" {
value="${aws_iam_user.genericuser.arn}"
}

output "iam_newuser_name" {
value="${aws_iam_user.genericuser.name}"
}

output "iam_newuser_uid" {
value="${aws_iam_user.genericuser.unique_id}"
}

#output "iam_newuser_accesskey" {
#value="${aws_iam_access_key.genericuserkey.id}"
#}