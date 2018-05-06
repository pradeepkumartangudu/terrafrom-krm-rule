#### EXAMPLE


# Role
#resource "aws_iam_role" "standardadmin_app_role" {
#    name = "standard_admin_app"
#    assume_role_policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#      {
#        "Action": "sts:AssumeRole",
#        "Principal": {
 #         "Service": "ec2.amazonaws.com"
#        },
#        "Effect": "Allow",
#        "Sid": ""
#      }
#    ]
#}
#EOF
#}

# Attach policy to role
#resource "aws_iam_role_policy_attachment" "attach-admin-core-app" {
#    role       = "${aws_iam_role.standardadmin_app_role.name}"
#    policy_arn = "${aws_iam_policy.standardadmin-core-policy.arn}"
#}

#resource "aws_iam_role_policy_attachment" "attach-admin-app" {
#    role       = "${aws_iam_role.standardadmin_app_role.name}"
#    policy_arn = "${aws_iam_policy.standardadmin_app_iam-policy.arn}"
#}

#resource "aws_iam_role_policy_attachment" "attach-base-app" {
#    role       = "${aws_iam_role.standardadmin_app_role.name}"
#    policy_arn = "${aws_iam_policy.baseiam-policy.arn}"
#}

#resource "aws_iam_role_policy_attachment" "attach-region-app" {
#    role       = "${aws_iam_role.standardadmin_app_role.name}"
#    policy_arn = "${aws_iam_policy.region-policy.arn}"
#}

#resource "aws_iam_role_policy_attachment" "attach-protectplatform-app" {
#    role       = "${aws_iam_role.standardadmin_app_role.name}"
#    policy_arn = "${aws_iam_policy.protect-platform-policy.arn}"
#}
