##########
#
# This is for the POC Team
#
# 


##############

data "aws_caller_identity" "accountnum" {}


#####
# IAM
#   

#group
resource "aws_iam_group" "pocteam" {
  name = "u-${var.environment}-${var.platform}-pocteam"
  path = "/foundation/${var.environment}/${var.platform}/"
}

#
resource "aws_iam_group_policy_attachment" "mfaattach" {

  group     = "${aws_iam_group.pocteam.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.accountnum.account_id}:policy/foundation/${var.environment}/${var.platform}/base_iam"

}



#
resource "aws_iam_group_policy_attachment" "protectattach" {

  group     = "${aws_iam_group.pocteam.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.accountnum.account_id}:policy/foundation/${var.environment}/${var.platform}/protectplatform"

}


#
resource "aws_iam_group_policy_attachment" "standardcore" {

  group     = "${aws_iam_group.pocteam.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.accountnum.account_id}:policy/foundation/${var.environment}/${var.platform}/standardadmin_core"

}