###########################################################
#  Account Wide Variables
#
#  These values will be use throughout your account.


#### Environment
variable "aws_region" { default = "us-east-1" }
variable "environment" { default = "nb" }
variable "appfamily" { default = "cdo" }
variable "platform" { default = "cdo" }
variable "owner" { default = "attbidw" }
variable "costcenter" { default = "attbidw" }
variable "foundation" { default = "true" }
variable "platform_bucket" { default="nb-mac-platformconfig-us-east-1" }

#### Network
variable "main_vpc_cidr" {
  description = "CIDR for the main VPC"
  default = "172.131.49.0/24" 
}

variable "private_subnet_a_cidr" {
  description = "CIDR for the Private Subnet A"
  default = "172.131.49.0/25" 
}

variable "private_subnet_b_cidr" {
  description = "CIDR for the Private Subnet B"
  default = "172.131.49.128/25" 
}

#### Leave Blank
variable "access_key" {}
variable "secret_key" {}
