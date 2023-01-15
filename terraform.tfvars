##Default variable for ECR.
//AWS_ACCESS_KEY = <"">
//AWS_SECRET_KEY = <"">

aws_region  = "af-south-1"
bucket_name = "sagar"

#-----------------------------------
#       SECURITY GROUP  
#-----------------------------------

# ingress_rules = {
#   "rule1" = {
#     "from_port"   = 80
#     "to_port"     = 80
#     "cidr_blocks" = ["0.0.0.0/0"]
#   }
#   "rule2" = {
#     "from_port"   = 443
#     "to_port"     = 443
#     "cidr_blocks" = ["0.0.0.0/0"]
#   },
#   "rule3" = {
#     "from_port"   = 8080
#     "to_port"     = 8080
#     "cidr_blocks" = ["0.0.0.0/0"]
#   }
# }



#-----------------------------------
#       ASG Variable
#-----------------------------------
ami_name                   = "name"
ami_value                  = "packer_ami_texe_1643104466"
vpc_id                     = "vpc-0aa739324660e4a8f"
launch_conf_name           = "cloud2-launch-conf"
launch_conf_instance_type  = "t3.medium"
launch_conf_sg             = "sg-02cf506fa0a374e40"
launch_conf_key_name       = "bastion_host"
launch_subnet_id           = ["subnet-07202e80d4cbdbe5a", "subnet-0df7d2310aa50ed7a", "subnet-04698e7aea93dd211"]
cloud_asg_name             = "cloud2-asg"
cloud_asg_max_capacity     = "1"
cloud_asg_min_capacity     = "1"
cloud_asg_desired_capacity = "1"

#------------------------------------
# LoadBalancer and Route 53 Variable
#------------------------------------
asg_alb_name             = "cloud2-asg-lb"
aws_lb_target_group_name = "cloud2-asg-target-grp"
asg_lb_sslpolicy         = "ELBSecurityPolicy-2016-08"
domain_name_asg          = "sagar.texecloudtest.xyz"
fqdn_name                = "texecloudtest.xyz"
asg_lb_hosted_zone       = "asg_lb_hosted_zone"
