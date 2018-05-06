variable "name" {}
variable "shortname" {}
variable "environment" {}
variable "foundation" {}
variable "costcenter" {}
variable "appfamily" {}
variable "platform" {}
variable "type" {}
variable "owner" {}
variable "aws_region" {}

resource "aws_s3_bucket" "app" {
  bucket = "${var.environment}-${var.platform}-${var.type}-${var.shortname}-${var.aws_region}"
  acl    = "private"

  tags {
    Name        = "${var.environment}-${var.platform}-${var.type}-${var.shortname}-${var.aws_region}"
    environment = "${var.environment}"
    foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    terraform   = "True"
  }

  lifecycle_rule {
    id      = "${var.environment}-${var.platform}-${var.type}-${var.shortname}-${var.aws_region}"
    enabled = true

    tags {
      rule        = "${var.environment}-${var.platform}-${var.type}-${var.shortname}-${var.aws_region}"
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
}

output "id" {
  value = "${aws_s3_bucket.app.id}"
}
