#-----------------------------------
#       GLOBAL VARIABLE
#-----------------------------------
//AWS_ACCESS_KEY = <"">
//AWS_SECRET_KEY = <"">
aws_region  = "ap-south-1"
bucket_name = "sagar"
env         = "test"
vpc_id      = "vpc-xxxxxx"

#-----------------------------------
#      LAUNCH TEMPLATE MODULE
#-----------------------------------
launch_conf_name          = "aws-launch-conf"
launch_conf_instance_type = "t3.medium"
launch_conf_key_name      = "jumper"

#-----------------------------------
#       ASG Variable
#-----------------------------------
ami_name  = "name"
ami_value = "ubuntu"

launch_subnet_id           = ["subnet-xx", "subnet-xx", "subnet-xxx"]
cloud_asg_name             = "cloud-asg"
cloud_asg_max_capacity     = "1"
cloud_asg_min_capacity     = "1"
cloud_asg_desired_capacity = "1"

#------------------------------------
# LoadBalancer and Route 53 Variable
#------------------------------------
asg_alb_name             = "cloud-asg-lb"
aws_lb_target_group_name = "cloud-asg-target-grp"
asg_lb_sslpolicy         = "ELBSecurityPolicy-2016-08"
domain_name_asg          = "abc.sagar.xyz"
fqdn_name                = "sagar.xyz"

#-----------------------------------
#      SECURITY GROUP VARIABLE
#-----------------------------------
aws_security_group_name_asg = "sagar-asg-security"
bastion_host_sg             = "sg-xxxx"

#-----------------------------------
#   ASG SCALING POLICY VARIABLE
#-----------------------------------
asg_scale_down_name = "testing-down"
asg_scale_up_name   = "testing-up"
