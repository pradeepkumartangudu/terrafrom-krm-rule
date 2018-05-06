#
#
#
#

#### Variables

data "aws_caller_identity" "current" {}
variable "environment" {}
variable "platform" {}
variable "policy_baseiam_arn" {}

#######


resource "aws_iam_group" "legacy_upstart_grp" {
  name = "${var.environment}-upstart_grp"
  path = "/foundation/${var.environment}/${var.platform}/"
}

resource "aws_iam_group" "legacy_admins_grp" {
  name = "${var.environment}-awsadmin_grp"
  path = "/foundation/${var.environment}/${var.platform}/"
}

resource "aws_iam_group" "legacy_ec2admins_grp" {
  name = "${var.environment}-ec2admin_grp"
  path = "/foundation/${var.environment}/${var.platform}/"
}

######

resource "aws_iam_policy" "legacy-upstart-policy" {
    name        = "g-policy-${var.environment}-upstart_grp"
	path        = "/foundation/${var.environment}/${var.platform}/"
    description = "legacy upstart policy"
	
	
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
			"Action": [
				"iam:Create*",
				"iam:Update*",
				"iam:Get*",
				"iam:Attach*",
				"iam:Delete*",
				"iam:List*",
				"iam:ChangePassword",
				"iam:AddUserToGroup",
				"iam:RemoveUserFromGroup",
				"iam:GenerateCredentialReport"
			],
			"Effect": "Allow",
			"Resource": "*"
		},
		{
			"Effect": "Deny",
			"Action": [
				"iam:Delete*",
				"iam:Update*"
			],
			"Resource": [
				"arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/svc*"
			]
		}
	]
}
	
EOF
	
}

resource "aws_iam_policy" "legacy-ec2admins-policy" {
    name        = "u-policy-${var.environment}-ec2admins_grp"
	path        = "/foundation/${var.environment}/${var.platform}/"
    description = "ec2admins policy"
	
	
	policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "ec2:AttachInternetGateway",
                "ec2:AttachVpnGateway",
                "ec2:CreateNatGateway",
                "ec2:CreateVpcPeeringConnection",
                "ec2:DeleteCustomerGateway",
                "ec2:DeleteDhcpOptions",
                "ec2:DeleteInternetGateway",
                "ec2:DeleteNetworkAcl",
                "ec2:DeleteNetworkAclEntry",
                "ec2:DeleteRoute",
                "ec2:DeleteRouteTable",
                "ec2:DeleteVpcPeeringConnection",
                "ec2:CreateCustomerGateway",
                "ec2:CreateInternetGateway",
                "ec2:CreateNetworkAcl",
                "ec2:CreateNetworkAcl",
                "ec2:CreateNetworkAclEntry",
                "ec2:CreateNetworkInterface",
                "ec2:CreateRoute",
                "ec2:CreateRouteTable",
                "ec2:CreateSubnet",
                "ec2:CreateVpc",
                "ec2:CreateVpcEndpoint",
                "ec2:CreateVpnConnection",
                "ec2:CreateVpnConnectionRoute",
                "ec2:CreateVpnGateway",
                "ec2:CreatePlacementGroup",
                "ec2:DeletePlacementGroup",
                "ec2:DeleteFlowLogs",
                "ec2:DeleteNatGateway",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteSubnet",
                "ec2:DeleteVpc",
                "ec2:DeleteVpcEndpoints",
                "ec2:DeleteVpnConnection",
                "ec2:DeleteVpnConnectionRoute",
                "ec2:DeleteVpnGateway",
                "ec2:DetachInternetGateway",
                "ec2:DetachNetworkInterface",
                "ec2:DetachVpnGateway",
                "ec2:DisableVgwRoutePropagation",
                "ec2:DisassociateAddress",
                "ec2:DisassociateRouteTable",
                "ec2:EnableVgwRoutePropagation",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:ModifySubnetAttribute",
                "ec2:ModifyVpcAttribute",
                "ec2:ModifyVpcEndpoint",
                "ec2:MoveAddressToVpc",
                "ec2:ReplaceNetworkAclAssociation",
                "ec2:ReplaceNetworkAclEntry",
                "ec2:ReplaceRoute",
                "ec2:ReplaceRouteTableAssociation",
                "ec2:ResetNetworkInterfaceAttribute",
                "ec2:RestoreAddressToClassic"
            ],
            "Resource": "*"
        },
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "arn:aws:ec2:us-east-1:${data.aws_caller_identity.current.account_id}:security-group/*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Action": [
                "iam:Get*",
                "iam:ListUsers"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
	
EOF
	
}


######

resource "aws_iam_group_policy_attachment" "legacy-upstart-group-attach" {
  group      = "${aws_iam_group.legacy_upstart_grp.name}"
  policy_arn = "${aws_iam_policy.legacy-upstart-policy.arn}"
}

resource "aws_iam_group_policy_attachment" "legacy-ec2admins-group-attach" {
  group      = "${aws_iam_group.legacy_ec2admins_grp.name}"
  policy_arn = "${aws_iam_policy.legacy-ec2admins-policy.arn}"
}

resource "aws_iam_group_policy_attachment" "legacy-ec2admins-group-attach-baseiam" {
  group      = "${aws_iam_group.legacy_ec2admins_grp.name}"
  policy_arn = "${var.policy_baseiam_arn}"
}

resource "aws_iam_group_policy_attachment" "legacy_admins_grp-group-attach" {
  group      = "${aws_iam_group.legacy_admins_grp.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "legacy_admins_grp-group-attach-baseiam" {
  group      = "${aws_iam_group.legacy_admins_grp.name}"
  policy_arn = "${var.policy_baseiam_arn}"
}

###
## get the group name
output "group_upstart_group_name" {
 value="${aws_iam_group.legacy_upstart_grp.name}"
}






