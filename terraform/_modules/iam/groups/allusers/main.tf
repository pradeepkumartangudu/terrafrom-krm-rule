#
# Global Group Definitions
#

#### Variables

data "aws_caller_identity" "current" {}
variable "environment" {}
variable "platform" {}

#variable "grp_allusers_s3bucket_name" {}

#######

resource "aws_iam_group" "allusers_grp" {
  name = "u-${var.environment}-${var.platform}-allusers"
  path = "/foundation/${var.environment}/${var.platform}/"
}

##### user group policy
resource "aws_iam_policy" "u_allusers-policy" {
  name        = "u-policy-u-${var.environment}-${var.platform}-allusers"
  path        = "/foundation/${var.environment}/${var.platform}/"
  description = "bucket acces policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "listingbuckets",
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
EOF
}

## make the association

resource "aws_iam_group_policy_attachment" "allusers_grp-group-attach" {
  group      = "${aws_iam_group.allusers_grp.name}"
  policy_arn = "${aws_iam_policy.u_allusers-policy.arn}"
}
