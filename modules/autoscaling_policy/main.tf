# -------------------------------------------------------
#         AUTO SCALING UP POLICY
# -------------------------------------------------------
resource "aws_autoscaling_policy" "scale_down" {
  name                   = var.asg_scale_down_name
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  policy_type = "SimpleScaling"
  scaling_adjustment     = -1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for Terramino ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = var.asg_scale_down_name
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "20"
  evaluation_periods  = "2"
  period              = "300"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# -------------------------------------------------------
#         AUTO SCALING DOWN POLICY
# -------------------------------------------------------

resource "aws_autoscaling_policy" "scale_up" {
  name                   = var.asg_scale_up_name
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  policy_type = "SimpleScaling"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization for Terramino ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = var.asg_scale_up_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "40"
  evaluation_periods  = "2"
  period              = "300"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}
