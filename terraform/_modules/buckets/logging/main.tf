// Special bucket for logging that needs slightly non standard policies.

variable "environment" {}
variable "foundation" {}
variable "costcenter" {}
variable "appfamily" {}
variable "platform" {}
variable "owner" {}
variable "aws_region" {}

variable "bkt_versioning" {
  default = false
}

variable "bkt_mfadelete" {
  default = false
}

#####
# Bucket
# 
resource "aws_s3_bucket" "logging" {
  bucket = "logging-${var.environment}-${var.platform}-${var.aws_region}"
  acl    = "private"

  tags {
    Name        = "logging-${var.environment}-${var.platform}-${var.aws_region}"
    environment = "${var.environment}"
    foundation  = "${var.foundation}"
    costcenter  = "${var.costcenter}"
    appfamily   = "${var.appfamily}"
    owner       = "${var.owner}"
    mfa_delete  = "${var.bkt_mfadelete}"
    terraform   = "True"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "${aws_kms_key.logging.id}"
      }
    }
  }

  versioning {
    enabled    = "${var.bkt_versioning}"
    mfa_delete = "${var.bkt_mfadelete}"
  }
}

#####
# Bucket Policy
#

module "loggings3bucketpolicy" {
  source        = "../../bucketpolicy/cloudtrail"
  s3_bucketName = "${aws_s3_bucket.logging.id}"
  kms_key_id    = "${aws_kms_key.logging.id}"
}

#####
# KMS
#  

resource "aws_kms_key" "logging" {
  description             = "KMS key for bucket logging-${var.environment}-${var.platform}-${var.aws_region}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags {
    Name = "logging-${var.environment}-${var.platform}-${var.aws_region}"
  }
}

resource "aws_kms_alias" "logging" {
  name          = "alias/logging-${var.environment}-${var.platform}-${var.aws_region}"
  target_key_id = "${aws_kms_key.logging.key_id}"
}

output "id" {
  value = "${aws_s3_bucket.logging.id}"
}
