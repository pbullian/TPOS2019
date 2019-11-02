resource "aws_flow_log" "grupo2" {
  iam_role_arn    = "${aws_iam_role.flowlog.arn}"
  log_destination = "${aws_cloudwatch_log_group.grupo2.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.G4.id}"
}

resource "aws_cloudwatch_log_group" "grupo2" {
  name = "flowlogs/grupo2"
tags {
    Name = "${var.environment}_FRONTEND_vm"     
    Project = "${var.project_name}"
  }
}

resource "aws_iam_role" "flowlog" {
  name = "flowlogRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "flowlogpolicy"
  role = "${aws_iam_role.flowlog.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
