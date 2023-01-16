#----------------------------------------------------------------
#   AUTO SCALING GROUP   
#----------------------------------------------------------------
resource "aws_autoscaling_group" "cloud_asg" {
  name                      = var.cloud_asg_name
  max_size                  = var.cloud_asg_max_capacity
  min_size                  = var.cloud_asg_min_capacity
  desired_capacity          = var.cloud_asg_desired_capacity
  force_delete              = true
  vpc_zone_identifier = var.launch_subnet_id

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  # HEALTH CHECK
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = ["${var.asg_lb_target}"]

  tag {
    key                 = "env"
    value               = "${var.env}"
    propagate_at_launch = true
  }
}