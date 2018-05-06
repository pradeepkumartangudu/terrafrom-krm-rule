variable "s3_bucketName" {}

resource "aws_s3_bucket_policy" "standardpolicyWtag" {
  bucket = "${var.s3_bucketName}"
  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "SSLOnlyAccess",
            "Effect": "Deny",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.s3_bucketName}",
                "arn:aws:s3:::${var.s3_bucketName}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.s3_bucketName}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "AES256"
                }
            }
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.s3_bucketName}/*",
            "Condition": {
                "Null": {
                    "s3:x-amz-server-side-encryption": "true"
                },

                "ForAllValues:StringLike": {
                    "s3:RequestObjectTagKeys": [
                        "costcenter"

                    ]
                },
                "ForAnyValue:StringLike": {
                    "s3:RequestObjectTagKeys": [

                        "costcenter"
                    ]
                }
            }
        }
    ]
}
POLICY
}
