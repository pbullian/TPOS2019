resource "aws_cloudwatch_metric_alarm" "cpu-ec2" {
  alarm_name                = "high-cpu-ec2"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  period                    = "300"
  datapoints_to_alarm       = "2"
  dimensions = {
    InstanceId = "${aws_instance.backend.id}"
  }

}
