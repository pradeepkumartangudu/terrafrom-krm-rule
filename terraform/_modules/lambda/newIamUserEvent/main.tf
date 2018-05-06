variable "group_name" {}
variable "sns_topic" {}
variable "subnet_a" {}
variable "subnet_b" {}
variable "security_group" {}
variable "environment" {}
variable "foundation" {}
variable "costcenter" {}
variable "appfamily" {}
variable "platform" {}
variable "owner" {}

# Lambda Roles
resource "aws_iam_role" "iam_for_lambda2" {
  name = "raws-${var.environment}-${var.platform}-lambda-attachGroup"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "iam-attachment" {
    name = "AWSLambdaVPCAccessExecutionRole"
    roles = ["${aws_iam_role.iam_for_lambda2.name}"]
    policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_lambda_function" "attachGroup" {
  filename         = "${path.module}/payload2.zip"
  function_name    = "attachGroup"
  description      = "Attach user to default groups when a new IAM user is created."
  role             = "${aws_iam_role.iam_for_lambda2.arn}"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = "${base64sha256(file("${path.module}/payload2.zip"))}"
  runtime          = "python2.7"
  timeout          = "300"
  environment {
      variables {
          group_name = "${var.group_name}"
      }
  }
  tags { 
    Foundation = "${var.foundation}",
    costcenter = "${var.costcenter}",
    appfamily = "${var.appfamily}",
    owner = "${var.owner}",
    environment = "${var.environment}"
  }
}


# Cloud Watch Trigger
resource "aws_cloudwatch_event_rule" "createUser" {
  name        = "createUser"
  description = "Capture new IAM users"

  event_pattern = <<PATTERN
{
    "source": [
        "aws.iam"
    ],
    "detail-type": [
        "AWS API Call via CloudTrail"
    ],
    "detail": {
        "eventSource": [
            "iam.amazonaws.com"
        ],
        "eventName": [
            "CreateUser"
        ]
    }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda2" {
  target_id = "TriggerAttachGroupLambda"
  rule      = "${aws_cloudwatch_event_rule.createUser.name}"
  arn       = "${aws_lambda_function.attachGroup.arn}"
}

resource "aws_lambda_permission" "attachGroup" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.attachGroup.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.createUser.arn}"
}

# Alarm

resource "aws_cloudwatch_metric_alarm" "errors2" {
    alarm_name = "Lambda - attachGroup - Errors"
    alarm_description = "Any errors in the attachGroup function."
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = "1"
    metric_name = "Errors"
    namespace = "AWS/Lambda"
    period = "300"
    statistic = "Sum"
    threshold = "0"
    insufficient_data_actions = []
    alarm_actions = ["${var.sns_topic}"]
    dimensions {
        FunctionName = "attachGroup"
    }
}

output "lambdarolearn" {
	value="${aws_iam_role.iam_for_lambda2.arn}"
}
