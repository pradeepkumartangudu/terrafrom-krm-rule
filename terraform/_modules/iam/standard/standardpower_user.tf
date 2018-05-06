


# Role
resource "aws_iam_role" "standard_power_user_role" {
	name = "${var.environment}-${var.platform}-standardpoweruser"
	path = "/foundation/${var.environment}/${var.platform}/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach-admin-core-poweruser" {
    role       = "${aws_iam_role.standard_power_user_role.name}"
    policy_arn = "${aws_iam_policy.standardadmin-core-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-admin-foundation-poweruser" {
    role       = "${aws_iam_role.standard_power_user_role.name}"
    policy_arn = "${aws_iam_policy.standardadmin-foundation-policy.arn}"
}


resource "aws_iam_role_policy_attachment" "attach-base-poweruser" {
    role       = "${aws_iam_role.standard_power_user_role.name}"
    policy_arn = "${aws_iam_policy.baseiam-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-region-poweruser" {
    role       = "${aws_iam_role.standard_power_user_role.name}"
    policy_arn = "${aws_iam_policy.region-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-protectplatform-poweruser" {
    role       = "${aws_iam_role.standard_power_user_role.name}"
    policy_arn = "${aws_iam_policy.protect-platform-policy.arn}"
}
