#
# Default Role Definitions
#

#### Variables
#
#

variable "environment" {}
variable "platform" {}


#### Definitions
#

####################### AWS Cloudtrail

resource "aws_iam_role" "cloudtrail" {

  name = "raws-${var.environment}-${var.platform}-cloudtrail-events"
  path = "/foundation/${var.environment}/${var.platform}/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-cloudtrail.json}"
}


data "aws_iam_policy_document" "instance-assume-cloudtrail" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}
####################### AWS Config

resource "aws_iam_role" "awsconfig" {

  name = "raws-${var.environment}-${var.platform}-awsconfig-resourceconfig"
  path = "/foundation/${var.environment}/${var.platform}/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-config.json}"

}

data "aws_iam_policy_document" "instance-assume-config" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attachdfactorypolicyconfig" {
    role       = "${aws_iam_role.awsconfig.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}


output "config_role_arn" {
	value="${aws_iam_role.awsconfig.arn}"
}


####################### Flow Logs

resource "aws_iam_role" "flowlogs" {

  name = "raws-${var.environment}-${var.platform}-flowlogs-networkmonitoring"
  path = "/foundation/${var.environment}/${var.platform}/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-vpcflowlogs.json}"
 
 
}

data "aws_iam_policy_document" "instance-assume-vpcflowlogs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}



output "vpc_flow_log_arn" {
	value="${aws_iam_role.flowlogs.arn}"
}

output "vpc_flow_log_name" {
	value="${aws_iam_role.flowlogs.name}"
}

#######################

resource "aws_iam_role" "platformdefaultemr" {

  name = "raws-${var.environment}-${var.platform}-emr-default"
  path = "/foundation/${var.environment}/${var.platform}/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-elasticmapreduce.json}"
 
}

resource "aws_iam_policy_attachment" "platformdefaultemrattach" {
  name       = "EMRdefaultAttach"
  roles      = ["${aws_iam_role.platformdefaultemr.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

data "aws_iam_policy_document" "instance-assume-elasticmapreduce" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }
  }
}


########
resource "aws_iam_role" "platformdefaultautoscale" {

  name = "raws-${var.environment}-${var.platform}-emr-autoscale"
  path = "/foundation/${var.environment}/${var.platform}/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-elasticmapreduceauto.json}"

 
}


resource "aws_iam_policy_attachment" "platformdefaultautoscaleattach" {
  name       = "EMRautoScaleAttach"
  roles      = ["${aws_iam_role.platformdefaultautoscale.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole"
}

data "aws_iam_policy_document" "instance-assume-elasticmapreduceauto" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com","application-autoscaling.amazonaws.com"]
    }
  }
}
