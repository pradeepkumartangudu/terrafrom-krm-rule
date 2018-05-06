variable "shortname" {}
variable "vpcshortname" {}
variable "environment" {}
variable "foundation" {}
variable "costcenter" {}
variable "appfamily" {}
variable "platform" {}
variable "owner" {}
variable "main_vpc_cidr" {}
variable "private_subnet_a_cidr" {}
variable "private_subnet_b_cidr" {}
variable "private_subnet_c_cidr" {}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.main_vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name        = "${var.environment}-${var.platform}-${var.vpcshortname}"
    Foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    environment = "${var.environment}"
  }
}

# S3 endpoint
resource "aws_vpc_endpoint" "private-s3" {
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private-s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.private-s3.id}"
  route_table_id  = "${aws_route_table.us-east-1-private.id}"
}

# Dynamo endpoint
resource "aws_vpc_endpoint" "private-dynamo" {
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "com.amazonaws.us-east-1.dynamodb"
}

resource "aws_vpc_endpoint_route_table_association" "private-dynamo" {
  vpc_endpoint_id = "${aws_vpc_endpoint.private-dynamo.id}"
  route_table_id  = "${aws_route_table.us-east-1-private.id}"
}

# Routes
resource "aws_route" "68" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "68.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "130" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "130.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "132" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "132.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "134" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "134.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "135" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "135.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "141" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "141.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "144" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "144.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "150" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "150.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "155" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "155.0.0.0/8"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route" "10-234" {
  route_table_id         = "${aws_route_table.us-east-1-private.id}"
  destination_cidr_block = "10.234.0.0/16"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

# Private gateway
resource "aws_route_table" "us-east-1-private" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.environment}-${var.platform}-rt-${var.shortname}-${var.vpcshortname}"
    Foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    environment = "${var.environment}"
  }
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.environment}-${var.platform}-gw-${var.shortname}-${var.vpcshortname}"
    Foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    environment = "${var.environment}"
  }
}

# Private Subnets
## Availability Zone A
resource "aws_subnet" "us-east-1a-private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnet_a_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name        = "${var.environment}-${var.platform}-piv1-us-east-1a"
    Foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "us-east-1a-private" {
  subnet_id      = "${aws_subnet.us-east-1a-private.id}"
  route_table_id = "${aws_route_table.us-east-1-private.id}"
}

## Availability Zone B
resource "aws_subnet" "us-east-1b-private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnet_b_cidr}"
  availability_zone = "us-east-1b"

  tags {
    Name        = "${var.environment}-${var.platform}-piv1-us-east-1b"
    Foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "us-east-1b-private" {
  subnet_id      = "${aws_subnet.us-east-1b-private.id}"
  route_table_id = "${aws_route_table.us-east-1-private.id}"
}

## Availability Zone C
resource "aws_subnet" "us-east-1c-private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnet_c_cidr}"
  availability_zone = "us-east-1c"

  tags {
    Name        = "${var.environment}-${var.platform}-piv1-us-east-1c"
    Foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "us-east-1c-private" {
  subnet_id      = "${aws_subnet.us-east-1c-private.id}"
  route_table_id = "${aws_route_table.us-east-1-private.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_endpoint" {
  value = "${aws_vpc_endpoint.private-s3.id}"
}

output "route_table_id" {
  value = "${aws_route_table.us-east-1-private.id}"
}

output "gateway_id" {
  value = "${aws_vpn_gateway.vpn_gw.id}"
}

output "vpc_cidr" {
  value = "${var.main_vpc_cidr}"
}

output "subnet_a" {
  value = "${aws_subnet.us-east-1a-private.id}"
}

output "subnet_b" {
  value = "${aws_subnet.us-east-1b-private.id}"
}

output "subnet_c" {
  value = "${aws_subnet.us-east-1c-private.id}"
}
