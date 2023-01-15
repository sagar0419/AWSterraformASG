#-------------------------------------------------------------------
#  AMI CONFIGURATION
#-------------------------------------------------------------------
data "aws_ami" "packer_ami" {
  most_recent = true
  filter {
    name   = var.ami_name
    values = ["${var.ami_value}"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["self"]
}

#----------------------------------------------------------------
#   AWS LAUNCH TEMPLATE
#----------------------------------------------------------------
resource "aws_launch_template" "cloud2_launch" {
  name                                 = var.launch_conf_name
  image_id                             = data.aws_ami.packer_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.launch_conf_instance_type
  key_name                             = var.launch_conf_key_name
  vpc_security_group_ids = ["${var.launch_conf_sg}"]
}

#----------------------------------------------------------------
#   AUTO SCALING GROUP   
#----------------------------------------------------------------

resource "aws_autoscaling_group" "cloud_asg" {
  name                      = var.cloud_asg_name
  max_size                  = var.cloud_asg_max_capacity
  min_size                  = var.cloud_asg_min_capacity
  desired_capacity          = var.cloud_asg_desired_capacity
  force_delete              = true
#  placement_group           = aws_placement_group.cloud2_placement.id
  vpc_zone_identifier = var.launch_subnet_id

  launch_template {
    id      = aws_launch_template.cloud2_launch.id
    version = "$Latest"
  }

  # HEALTH CHECK
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = ["${var.asg_lb_target}"]

  tag {
    key                 = "name"
    value               = "cloud2-texecom-asg"
    propagate_at_launch = true
  }
}