###########################################################
#  bidwsecurity - main.tf
#
#  Configures your account with variables.tf

#############################
# Buckets
#

#### Logging Bucket
module "logging3bucket" {
  source         = "../_modules/buckets/logging"
  environment    = "${var.environment}"
  foundation     = "${var.foundation}"
  costcenter     = "${var.costcenter}"
  appfamily      = "${var.appfamily}"
  platform       = "${var.platform}"
  owner          = "${var.owner}"
  aws_region     = "${var.aws_region}"
  bkt_versioning = true
  bkt_mfadelete  = false                         # Set manually then enable here. (requires root account)
}

module "platforms3bucketpolicy" {
  source        = "../_modules/bucketpolicy/platform_config"
  s3_bucketName = "${var.platform_bucket}"
  kms_key_id    = "arn:aws:kms:us-east-1:695019450051:key/24a9988d-8084-4a85-b53b-f4d0af1ccd6a"
}

#### Home Bucket
module "homes3bucket" {
  source      = "../_modules/buckets/classic"
  name        = "${var.environment}-bidw-home"
  environment = "${var.environment}"
  foundation  = "${var.foundation}"
  costcenter  = "${var.costcenter}"
  appfamily   = "${var.appfamily}"
  platform    = "${var.platform}"
  owner       = "${var.owner}"
  aws_region  = "${var.aws_region}"
}

module "homes3bucketpolicy" {
  source         = "../_modules/bucketpolicy/kingsmountain"
  s3_bucketName  = "${module.homes3bucket.id}"
  vpc-identifier = "${module.vpc.vpc_id}"
}

#### already existing platform bucket policy
#module "platforms3bucketpolicy" {
#  source        = "../_modules/bucketpolicy/standard"
#  s3_bucketName = "${var.platform_bucket}"
#}

#
#############################
# Cloudwatch
#

#### Flowlogs
module "cloudwatchgeneric_vpc" {
  source      = "../_modules/cloudwatch/standard"
  shortname   = "flowlogs"
  environment = "${var.environment}"
  foundation  = "${var.foundation}"
  costcenter  = "${var.costcenter}"
  appfamily   = "${var.appfamily}"
  platform    = "${var.platform}"
  owner       = "${var.owner}"
  aws_region  = "${var.aws_region}"
}

resource "aws_flow_log" "flow_log" {
  log_group_name = "${module.cloudwatchgeneric_vpc.name}"
  iam_role_arn   = "${module.iam_roles.vpc_flow_log_arn}"
  vpc_id         = "${module.vpc.vpc_id}"
  traffic_type   = "ALL"
}

resource "aws_iam_role_policy_attachment" "attach-vpc-flow-policy" {
  role       = "${module.iam_roles.vpc_flow_log_name}"
  policy_arn = "${module.iam_core.p_generic_cldwtchlog_arn}"
}

#############################
# Cloud Trail
#

module "cloudtrail_standard" {
  source        = "../_modules/cloudtrail/standard"
  logS3BucketId = "${module.logging3bucket.id}"
}

#############################
# SNS Notifications
#

resource "aws_sns_topic" "main" {
  name         = "infra_alerts"
  display_name = "Infrastructure Alerts"
}

#############################
# Network
#

#### Main VPC
module "vpc" {
  source                = "../_modules/vpc/four_subnets"
  shortname             = "main"
  vpcshortname          = "main"
  environment           = "${var.environment}"
  foundation            = "true"
  costcenter            = "${var.costcenter}"
  appfamily             = "${var.platform}"
  platform              = "${var.platform}"
  owner                 = "${var.owner}"
  main_vpc_cidr         = "${var.main_vpc_cidr}"
  private_subnet_a_cidr = "${var.private_subnet_a_cidr}"
  private_subnet_b_cidr = "${var.private_subnet_b_cidr}"
  private_subnet_c_cidr = "${var.private_subnet_c_cidr}"
  private_subnet_d_cidr = "${var.private_subnet_d_cidr}"
}

#resource "aws_route" "nat-gateway" {
#  route_table_id = "${module.vpc.route_table_id}"
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = "nat-00f8f8639941a5ec8"
#}

#############################
# Iam
#

#### Groups
module "iam_groups" {
  source      = "../_global/iam/group"
  platform    = "${var.platform}"
  environment = "${var.environment}"
}

#### Roles
module "iam_roles" {
  source      = "../_global/iam/role"
  platform    = "${var.platform}"
  environment = "${var.environment}"
}

#### Core
module "iam_core" {
  source      = "../_modules/iam/standard"
  platform    = "${var.platform}"
  environment = "${var.environment}"
}

#### legacy
module "iam_legacy" {
  source             = "../_modules/iam/groups/legacy"
  platform           = "${var.platform}"
  environment        = "${var.environment}"
  policy_baseiam_arn = "${module.iam_core.p_generic_baseiam_arn}"
}

#### all users
module "iam_all_users" {
  source                     = "../_modules/iam/groups/allusers"
  platform                   = "${var.platform}"
  environment                = "${var.environment}"
  grp_allusers_s3bucket_name = "${module.homes3bucket.id}"
}

### upstart user
module "iam_upstart_user" {
  source        = "../_modules/iam/user_wkeys"
  iam_user_name = "upstart"
}

### upstart svc account group
resource "aws_iam_group_membership" "upstartGroup" {
  name  = "upstartGroup"
  users = ["${module.iam_upstart_user.iam_newuser_name}"]
  group = "${module.iam_legacy.group_upstart_group_name}"
}

### terraform svc along side the role
module "iam_terraform_user" {
  source        = "../_modules/iam/user_wkeys"
  iam_user_name = "svc-${var.environment}-${var.platform}-terraformautomation"
}

### terraform svc account group
resource "aws_iam_group_membership" "terraformGroup" {
  name  = "terraformGroup"
  users = ["${module.iam_terraform_user.iam_newuser_name}"]
  group = "${module.iam_groups.group_platform_automation_name}"
}

###
resource "aws_iam_group_policy_attachment" "terraform_grp-group-attach" {
  group      = "${module.iam_groups.group_platform_automation_name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

### attachment hack until refactor for platform admins
module "legacy_policy_group_attach" {
  source                     = "../_global/iam/attach"
  pltadms-grp                = "${module.iam_groups.group_platform_admins_name}"
  policy_baseiam_arn         = "${module.iam_core.p_generic_baseiam_arn}"
  policy_protectplatform_arn = "${module.iam_core.p_generic_protect-platform-policy_arn}"
  policy_standardadmin_arn   = "${module.iam_core.p_generic_standardadmin-core-policy_arn}"
}

#############################
# Security Groups
#
module "securitygroups" {
  source   = "../_modules/securitygroups/standard"
  vpc_id   = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr}"
}

#############################
# Lambda Functions
#

#### newIamUserEvent via Upstart
module "lambda_newIamUserEvent" {
  source         = "../_modules/lambda/newIamUserEvent"
  group_name     = "u-${var.environment}-${var.platform}-allusers"
  sns_topic      = "${aws_sns_topic.main.arn}"
  environment    = "${var.environment}"
  platform       = "${var.platform}"
  foundation     = "${var.foundation}"
  costcenter     = "${var.costcenter}"
  appfamily      = "${var.appfamily}"
  owner          = "${var.owner}"
  subnet_a       = "${module.vpc.subnet_a}"
  subnet_b       = "${module.vpc.subnet_b}"
  security_group = "${module.securitygroups.id}"
}

########
output "upstart_ak" {
  value = "${module.iam_upstart_user.iam_newuser_accesskey}"
}

output "upstart_sk" {
  value = "${module.iam_upstart_user.iam_newuser_secretkey}"
}
