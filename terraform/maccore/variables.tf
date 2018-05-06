###########################################################
#  Account Wide Variables
#
#  These values will be use throughout your account.


#### Environment
variable "aws_region" { default = "us-east-1" }
variable "environment" { default = "mc" }
variable "appfamily" { default = "mac" }
variable "platform" { default = "mac" }
variable "costcenter" { default = "attbidw" }
variable "owner" { default = "attbidw" }
variable "foundation" { default = "true" }
variable "platform_bucket" { default="mc-mac-platformconfig-us-east-1" }

#### Network
variable "main_vpc_cidr" {
  description = "CIDR for the main VPC"
  default = "130.6.229.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR for the Private Subnet A"
  default = "130.6.229.0/26"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for the Private Subnet B"
  default = "130.6.229.64/26"
}

variable "private_subnet_c_cidr" {
  description = "CIDR for the Private Subnet C"
  default = "130.6.229.128/26"
}

variable "private_subnet_d_cidr" {
  description = "CIDR for the Private Subnet d"
  default = "130.6.229.192/26"
}

#### Leave Blank
variable "access_key" {}
variable "secret_key" {}
