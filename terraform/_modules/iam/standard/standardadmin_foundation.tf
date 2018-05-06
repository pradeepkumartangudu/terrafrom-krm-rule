#this is actually the platform admin


# Role
resource "aws_iam_role" "standardadmin_role" {
	name = "${var.environment}-${var.platform}-platformadmin"
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
resource "aws_iam_role_policy_attachment" "attach-admin-core" {
    role       = "${aws_iam_role.standardadmin_role.name}"
    policy_arn = "${aws_iam_policy.standardadmin-core-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-admin-foundation-core" {
    role       = "${aws_iam_role.standardadmin_role.name}"
    policy_arn = "${aws_iam_policy.standardadmin-foundation-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-base" {
    role       = "${aws_iam_role.standardadmin_role.name}"
    policy_arn = "${aws_iam_policy.baseiam-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-region" {
    role       = "${aws_iam_role.standardadmin_role.name}"
    policy_arn = "${aws_iam_policy.region-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach-protectplatform" {
    role       = "${aws_iam_role.standardadmin_role.name}"
    policy_arn = "${aws_iam_policy.protect-platform-policy.arn}"
}
