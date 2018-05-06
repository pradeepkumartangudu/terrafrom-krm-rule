variable "name" {}
variable "environment" {}
variable "foundation" {}
variable "costcenter" {}
variable "appfamily" {}
variable "platform" {}
variable "owner" {}
variable "aws_region" {}

variable "customerid" {
  default = ""
}

variable "appid" {
  default = ""
}

variable "partnerid" {
  default = ""
}

variable "compliance" {
  default = ""
}

variable "bkt_versioning" {
  default = false
}

variable "bkt_mfadelete" {
  default = false
}

resource "aws_s3_bucket" "generic" {
  bucket = "${var.name}"
  acl    = "private"

  tags {
    Name        = "${var.name}"
    environment = "${var.environment}"
    foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    customerid  = "${var.customerid}"
    appid       = "${var.appid}"
    partnerid   = "${var.partnerid}"
    compliance  = "${var.compliance}"
    terraform   = "True"
  }

  lifecycle_rule {
    id      = "${var.environment}-${var.platform}-${var.name}-${var.aws_region}"
    enabled = true

    tags {
      rule        = "${var.environment}-${var.platform}-${var.name}-${var.aws_region}"
      autoclean   = "true"
      environment = "${var.environment}"
      foundation  = "${var.foundation}"
      costcenter  = "${var.costcenter}"
      appfamily   = "${var.appfamily}"
      owner       = "${var.owner}"
      terraform   = "True"
    }

    transition {
      days          = 730
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = "${var.bkt_versioning}"
    mfa_delete = "${var.bkt_mfadelete}"
  }
}

output "id" {
  value = "${aws_s3_bucket.generic.id}"
}
