#-----------------------------------
#       GLOBAL VARIABLE
#-----------------------------------
//variable "AWS_ACCESS_KEY" {}
//variable "AWS_SECRET_KEY" {}
variable "aws_region" {}
variable "bucket_name" {}
variable "env" {}
variable "ami_name" {}
variable "ami_value" {}
variable "vpc_id" {}

#-----------------------------------
#      LAUNCH TEMPLATE MODULE
#-----------------------------------
variable "launch_conf_name" {}
variable "launch_conf_instance_type" {}
variable "launch_conf_key_name" {}

#-----------------------------------
#       ASG Variable
#-----------------------------------
variable "launch_subnet_id" {}
variable "cloud_asg_name" {}
variable "cloud_asg_max_capacity" {}
variable "cloud_asg_min_capacity" {}
variable "cloud_asg_desired_capacity" {}

#------------------------------------
# LoadBalancer and Route 53 Variable
#------------------------------------
variable "asg_alb_name" {}
variable "asg_lb_sslpolicy" {}
variable "aws_lb_target_group_name" {}
variable "domain_name_asg" {}
variable "fqdn_name" {}

#-----------------------------------
#      SECURITY GROUP Variable
#-----------------------------------
variable "aws_security_group_name_asg" {}
variable "bastion_host_sg" {}

# -------------------------------------------------------
#         AUTO SCALING POLICY MODULE
# -------------------------------------------------------
variable "asg_scale_down_name" {}
variable "asg_scale_up_name" {}
