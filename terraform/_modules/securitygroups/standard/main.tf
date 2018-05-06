# TODO: Finish
variable "vpc_id" {}

variable "vpc_cidr" {}

resource "aws_security_group" "allow_vpc" {
  name        = "allow_vpc"
  description = "Allow all inbound traffic from the vpc"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Default aws rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kings_mountain" {
  name        = "kings_mountain"
  description = "Allow all inbound traffic from the kings mountain"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.234.0.0/16", "68.0.0.0/8", "130.0.0.0/8", "132.0.0.0/8", "134.0.0.0/8", "135.0.0.0/8", "141.0.0.0/8", "144.0.0.0/8", "150.0.0.0/8", "155.0.0.0/8"]
    description = "Kings Mountain cidr block"
  }

  # Default aws rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "id" {
  value = "${aws_security_group.allow_vpc.id}"
}
