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
  vpc_security_group_ids = ["${var.aws_security_group_name}"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      name = var.launch_conf_name
      env = var.env
    }
  }
  user_data =  filebase64("${path.module}/userdata.sh")
}