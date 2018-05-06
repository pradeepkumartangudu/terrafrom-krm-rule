###########################################################
#  Account Wide Variables
#
#  These values will be use throughout your account.

#### Environment
variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "pr"
}

variable "appfamily" {
  default = "ip"
}

variable "platform" {
  default = "ip"
}

variable "owner" {
  default = ""
}

variable "costcenter" {
  default = ""
}

variable "foundation" {
  default = "true"
}

variable "platform_bucket" {
  default = "pr-ip-platformconfig-us-east-1"
}

#### Network
variable "main_vpc_cidr" {
  description = "CIDR for the main VPC"
  default     = "130.6.231.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR for the Private Subnet A"
  default     = "130.6.231.0/26"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for the Private Subnet B"
  default     = "130.6.231.64/26"
}

variable "private_subnet_c_cidr" {
  description = "CIDR for the Private Subnet C"
  default     = "130.6.231.128/26"
}

variable "private_subnet_d_cidr" {
  description = "CIDR for the Private Subnet D"
  default     = "130.6.231.192/26"
}

#### Leave Blank
variable "access_key" {}

variable "secret_key" {}
