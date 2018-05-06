data "aws_caller_identity" "current" {}

# Super Admin
resource "aws_iam_policy" "superadmin-policy" {
    name        = "superadmin"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Super Admin Policy"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF

}

# Standard Admin
resource "aws_iam_policy" "standardadmin-core-policy" {
    name        = "standardadmin_core"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Standard Admin Core Policy"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "StmtAllowStandardAdmin",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "acm:*",
                "apigateway:*",
                "application-autoscaling:*",
                "appstream:*",
                "autoscaling:*",
                "aws-marketplace:*",
                "aws-portal:*",
                "batch:*",
                "clouddirectory:*",
                "cloudfront:*",
                "cloudformation:*",
                "cloudsearch:*",
                "cloudtrail:*",
                "cloudwatch:*",
                "codebuild:*",
                "codecommit:*",
                "codedeploy:*",
                "codepipeline:*",
                "cognito-identity:*",
                "cognito-sync:*",
                "config:*",
                "connect:*",
                "cur:*",
                "datapipeline:*",
                "devicefarm:*",
                "dms:*",
                "dynamodb:*",
                "ecr:*",
                "ecs:*",
                "elasticache:*",
                "elasticbeanstalk:*",
                "elasticfilesystem:*",
                "elasticloadbalancing:*",
                "elasticmapreduce:*",
                "elastictranscoder:*",
                "es:*",
                "events:*",
                "execute-api:*",
                "firehose:*",
                "gamelift:*",
                "glacier:*",
                "health:*",
                "importexport:*",
                "inspector:*",
                "iot:*",
                "kinesis:*",
                "kms:*",
                "lambda:*",
                "logs:*",
                "machinelearning:*",
                "mobileanalytics:*",
                "mobilehub:*",
                "mobiletargeting:*",
                "polly:*",
                "rds:*",
                "redshift:*",
                "rekognition:*",
                "route53:*",
                "route53domains:*",
                "s3:*",
                "sdb:*",
                "servicecatalog:*",
                "ses:*",
                "shield:*",
                "sns:*",
                "sqs:*",
                "ssm:*",
                "states:*",
                "support:*",
                "swf:*",
                "tag:*",
                "trustedadvisor:*",
                "waf:*",
                "waf-regional:*",
                "wam:*",
                "xray:*",
                "ec2:*",
                "iam:*"
            ]
        }
    ]
}
EOF

}


# Base IAM
resource "aws_iam_policy" "baseiam-policy" {
    name        = "base_iam"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Base IAM Policy"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAllUsersToListAccounts",
            "Effect": "Allow",
            "Action": [
                "iam:ListAccountAliases",
                "iam:ListUsers",
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowIndividualUserToSeeAndManageOnlyTheirOwnAccountInformation",
            "Effect": "Allow",
            "Action": [
               
                "iam:CreateAccessKey",
               
                "iam:DeleteAccessKey",
                "iam:DeleteLoginProfile",
                "iam:GetLoginProfile",
                "iam:ListAccessKeys",
                "iam:UpdateAccessKey",
                "iam:UpdateLoginProfile",
                "iam:ListSigningCertificates",
                "iam:DeleteSigningCertificate",
                "iam:UpdateSigningCertificate",
                "iam:UploadSigningCertificate",
                "iam:ListSSHPublicKeys",
                "iam:GetSSHPublicKey",
                "iam:DeleteSSHPublicKey",
                "iam:UpdateSSHPublicKey",
                "iam:UploadSSHPublicKey"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
        },
        {
            "Sid": "AllowIndividualUserToListOnlyTheirOwnMFA",
            "Effect": "Allow",
            "Action": [
                "iam:ListVirtualMFADevices",
                "iam:ListMFADevices"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToManageTheirOwnMFA",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA",
            "Effect": "Allow",
            "Action": [
                "iam:DeactivateMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
            ],
            "Condition": {
                "Bool": {
                    "aws:MultiFactorAuthPresent": "true"
                }
            }
        },
        {
            "Sid": "BlockMostAccessUnlessSignedInWithMFA",
            "Effect": "Deny",
            "NotAction": [
                 "iam:ChangePassword",
                  "iam:CreateLoginProfile",
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:ListVirtualMFADevices",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice",
                "iam:ListAccountAliases",
                "iam:ListUsers",
                "iam:ListSSHPublicKeys",
                "iam:ListAccessKeys",
                "iam:ListServiceSpecificCredentials",
                "iam:ListMFADevices",
                "iam:GetAccountSummary",
                "sts:GetSessionToken"
            ],
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        }
    ]
}
EOF

}

# Standard Admin App IAM
resource "aws_iam_policy" "standardadmin_app_iam-policy" {
    name        = "standardadmin_app_iam"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Standard Admin App IAM"

    policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Sid":"StmtDenySSOManipulation",
            "Resource":"*",
            "Effect":"Deny",
            "Action":[
                "iam:UpdateSAMLProvider",
                "iam:UpdateOpenIDConnect*",
                "iam:DeleteAccountPassword",
                "iam:DeleteSAMLProvider",
                "iam:DeleteOpenIDConnect"
            ]
        },
        {
            "Resource":[
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:group/apps/*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/apps/*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/apps/*"
            ],
            "Effect":"Allow",
            "Action":[
                "iam:PassRole",
                "iam:AddRoleToInstanceProfile",
                "iam:AddUserToGroup",
                "iam:ChangePassword",
                "iam:CreateAccessKey",
                "iam:CreateGroup",
                "iam:CreateInstanceProfile",
                "iam:CreateLoginProfile",
                "iam:CreateRole",
                "iam:DeleteAccessKey",
                "iam:DeleteGroup",
                "iam:DeleteInstanceProfile",
                "iam:DeleteLoginProfile",
                "iam:DeleteRole",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:RemoveUserFromGroup",
                "iam:UpdateAccessKey",
                "iam:UpdateGroup",
                "iam:UpdateLoginProfile",
                "iam:DeleteGroupPolicy",
                "iam:DeleteRolePolicy",
                "iam:UpdateAssumeRolePolicy",
                "iam:GenerateCredentialReport",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:SimulateCustomPolicy",
                "iam:SimulatePrincipalPolicy",
                "iam:Get*",
                "iam:List*"
            ]
        },
        {
            "Condition":{
                "ArnNotLike":{
                    "iam:PolicyArn":"arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/apps*"
                }
            },
            "Action":[
                "iam:Detach*",
                "iam:Attach*"
            ],
            "Resource":"*",
            "Effect":"Deny"
        }
    ]
}
EOF

}

# Region
resource "aws_iam_policy" "region-policy" {
    name        = "region"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Region IAM Policy"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Action": "*",
        "Effect": "Deny",
        "Resource": "arn:aws:ec2:*",
        "Condition": {
            "StringNotEquals": { "ec2:Region" : ["us-west-2","us-east-1"] }
        }
    }
}
EOF

}

# Protect Platform
resource "aws_iam_policy" "protect-platform-policy" {
    name        = "protectplatform"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Protect Platform Policy"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "StmtDenyRemoveBuckets",
            "Effect": "Deny",
            "Action": [
                "s3:DeleteBucket*",
                "s3:DeleteBucketPolicy",
                "s3:DeleteObject*",
                "s3:PutBucket*"
            ],
            "Resource": ["arn:aws:s3:::logging-${var.environment}-${var.platform}-us-east-1" ]
        },
        {
            "Sid": "StmtDenyDeletePlatformBucket",
            "Effect": "Deny",
            "Action": [
                "s3:DeleteBucket*"
            ],
            "Resource": ["arn:aws:s3:::${var.environment}-${var.platform}-platformconfig-us-east-1"]
        },
        {
            "Sid": "StmtDenyDeleteTerraformRuntime",
            "Effect": "Deny",
            "Action": [
                "s3:Delete*"
            ],
            "Resource": ["arn:aws:s3:::${var.environment}-${var.platform}-platformconfig-us-east-1/runtime*"]
        },
        {
            "Sid": "StmtDenyCloudTrail",
            "Effect": "Deny",
            "Action": [
                "cloudtrail:DeleteTrail",
                "cloudtrail:UpdateTrail",
                "cloudtrail:StopLogging",
                "cloudtrail:PutEventSelectors"
            ],
            "Resource": [
                "arn:aws:cloudtrail:us-east-1:${data.aws_caller_identity.current.account_id}:trail/ManagementEvents",
                "arn:aws:cloudtrail:us-east-1:${data.aws_caller_identity.current.account_id}:trail/FWDManagementEvents",
                "arn:aws:cloudtrail:us-east-1:${data.aws_caller_identity.current.account_id}:trail/ObjectEvents",
                "arn:aws:cloudtrail:us-east-1:${data.aws_caller_identity.current.account_id}:trail/FWDObjectEvents"
            ]
        },
        {
            "Sid": "Stmtplatformadminnomanipulatepolicy",
            "Condition":{
                "ArnLike":{
                    "iam:PolicyArn":"arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/foundation*"
                }
            },
            "Action":[
                "iam:Detach*Policy",
                "iam:Attach*Policy"
            ],
            "Resource":[
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:group/foundation*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/foundation*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/foundation*"
            ],
            "Effect":"Deny"
        },
        {
            "Sid":"stmtcannotremovepolicies",
            "Effect":"Deny",
            "Action": [
                "iam:DeletePolicy"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/foundation*"
        }
    ]
}
EOF

}

# Standard Admin Foundation
resource "aws_iam_policy" "standardadmin-foundation-policy" {
    name        = "standardadmin_foundation_iam"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Standard Admin Foundation Policy"

    policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Sid":"StmtDenySSOManipulation",
            "Resource":"*",
            "Effect":"Deny",
            "Action":[
                "iam:UpdateSAMLProvider",
                "iam:UpdateOpenIDConnect*",
                "iam:DeleteAccountPassword",
                "iam:DeleteSAMLProvider",
                "iam:DeleteOpenIDConnect"
            ]
        },
        {
            "Resource":[
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:group/foundation/*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/foundation/*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/foundation/*"
            ],
            "Effect":"Allow",
            "Action":[
                "iam:PassRole",
                "iam:AssumeRole",
                "iam:AddRoleToInstanceProfile",
                "iam:AddUserToGroup",
                "iam:ChangePassword",
                "iam:CreateAccessKey",
                "iam:CreateGroup",
                "iam:CreateInstanceProfile",
                "iam:CreateLoginProfile",
                "iam:CreateRole",
                "iam:DeleteAccessKey",
                "iam:DeleteGroup",
                "iam:DeleteInstanceProfile",
                "iam:DeleteLoginProfile",
                "iam:DeleteRole",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:RemoveUserFromGroup",
                "iam:UpdateAccessKey",
                "iam:UpdateGroup",
                "iam:UpdateLoginProfile",
                "iam:UpdateUser",
                "iam:DeleteGroupPolicy",
                "iam:DeleteRolePolicy",
                "iam:DeleteUserPolicy",
                "iam:UpdateAssumeRolePolicy",
                "iam:GenerateCredentialReport",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:SimulateCustomPolicy",
                "iam:SimulatePrincipalPolicy",
                "iam:Get*",
                "iam:List*"
            ]
        },
        {
            "Condition":{
                "ArnNotLike":{
                    "iam:PolicyArn":"arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/foundation*"
                }
            },
            "Action":[
                "iam:Detach*",
                "iam:Attach*"
            ],
            "Resource":"*",
            "Effect":"Deny"
        }
    ]
}
EOF

}


# Standard Admin Foundation
resource "aws_iam_policy" "generic-cldwtchlog-policy" {
    name        = "GenericCldWtchLogsWriter"
    path        = "/foundation/${var.environment}/${var.platform}/"
    description = "Generic Cloud Watch Log Policy"
	
	
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": [
			"logs:CreateLogGroup",
			"logs:CreateLogStream",
			"logs:PutLogEvents",
			"logs:DescribeLogGroups",
			"logs:DescribeLogStreams"
		],
		"Effect": "Allow",
		"Resource": "*"
	}]
}	
	
EOF
	
}
	


######
output "p_generic_cldwtchlog_arn" {
	value="${aws_iam_policy.generic-cldwtchlog-policy.arn}"
}

output "p_generic_cldwtchlog_id" {
	value="${aws_iam_policy.generic-cldwtchlog-policy.id}"
}

output "p_generic_baseiam_arn" {
	value="${aws_iam_policy.baseiam-policy.arn}"
}

output "p_generic_standardadmin-core-policy_arn" {
	value="${aws_iam_policy.standardadmin-core-policy.arn}"
}

output "p_generic_protect-platform-policy_arn" {
	value="${aws_iam_policy.protect-platform-policy.arn}"
}