#
#

variable "logS3BucketId" {}

resource "aws_cloudtrail" "mainwlogs" {
    name = "ManagementEvents"
    s3_bucket_name = "${var.logS3BucketId}"
    is_multi_region_trail = true
    enable_log_file_validation = true
}
