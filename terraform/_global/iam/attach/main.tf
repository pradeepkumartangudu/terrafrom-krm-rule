#
# TEMP until the refactor task is complete
#

variable "pltadms-grp" {}
variable "policy_baseiam_arn" {}
variable "policy_standardadmin_arn" {}
variable "policy_protectplatform_arn" {}

resource "aws_iam_group_policy_attachment" "prerefactor_platformadmins-group-attach-baseiam" {
  group      = "${var.pltadms-grp}"
  policy_arn = "${var.policy_baseiam_arn}"
}

resource "aws_iam_group_policy_attachment" "prerefactor_platformadmins-group-attach-standardadmin" {
  group      = "${var.pltadms-grp}"
  policy_arn = "${var.policy_standardadmin_arn}"
}

resource "aws_iam_group_policy_attachment" "prerefactor_platformadmins-group-attach-protectplatform" {
  group      = "${var.pltadms-grp}"
  policy_arn = "${var.policy_protectplatform_arn}"
}