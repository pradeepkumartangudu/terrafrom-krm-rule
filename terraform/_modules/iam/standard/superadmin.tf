variable "environment" {}
variable "platform" {}

# Role
resource "aws_iam_role" "superadmin_role" {
    name = "${var.environment}-${var.platform}-superadmin"
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
resource "aws_iam_role_policy_attachment" "attach" {
    role       = "${aws_iam_role.superadmin_role.name}"
    policy_arn = "${aws_iam_policy.superadmin-policy.arn}"
}
