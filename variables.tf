//variable "AWS_ACCESS_KEY" {}
//variable "AWS_SECRET_KEY" {}
variable "aws_region" {}
variable "bucket_name" {}

#-----------------------------------
#       ASG Variable
#-----------------------------------
variable "ami_name" {}
variable "ami_value" {}
variable "vpc_id" {}
variable "launch_conf_name" {}
variable "launch_conf_instance_type" {}
variable "launch_conf_sg" {}
variable "launch_conf_key_name" {}
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
variable "asg_lb_hosted_zone" {}
variable "fqdn_name" {}