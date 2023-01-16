# -------------------------------------------------------
#      PROVIDER
# -------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------------------------------------
#      TERRAFORM STATEFILE
# -------------------------------------------------------
# terraform {
#   backend "s3" {
#     bucket = "terraform-backup-sagar"
#     region = var.aws_region
#     key    = "backup.tfstate"
#   }
# }

#--------------------------------------------------------
#      ROUTE 53 MODULE
#--------------------------------------------------------
module "route53" {
  source = "./modules/route53"

  domain_name_asg = var.domain_name_asg
  fqdn_name       = var.fqdn_name
  asg_alb_dns     = module.loadbalancer.asg_alb_dns
  asg_alb_zone    = module.loadbalancer.asg_alb_zone
}

#--------------------------------------------------------
#      ACM SSL MODULE
#--------------------------------------------------------
module "acm_ssl" {
  source = "./modules/acm_ssl"

  domain_name_asg = var.domain_name_asg
  fqdn_name       = var.fqdn_name
}

#--------------------------------------------------------
#      SECURITY GROUP MODULE
#--------------------------------------------------------
module "security_group" {
  source = "./modules/security_group"

  env                         = var.env
  vpc_id                      = var.vpc_id
  aws_security_group_name_asg = var.aws_security_group_name_asg
  bastion_host_sg             = var.bastion_host_sg
}

#--------------------------------------------------------
#      LAUNCH TEMPLATE MODULE
#--------------------------------------------------------
module "launch_template" {
  source = "./modules/launch_template"

  ami_name                  = var.ami_name
  ami_value                 = var.ami_value
  env                       = var.env
  launch_conf_name          = var.launch_conf_name
  launch_conf_instance_type = var.launch_conf_instance_type
  aws_security_group_name   = module.security_group.aws_security_group_name
  launch_conf_key_name      = var.launch_conf_key_name
}

#--------------------------------------------------------
#      AUTO SCALING MODULE
#--------------------------------------------------------
module "autoscaling_group" {
  source = "./modules/autoscaling_group"

  env                        = var.env
  launch_subnet_id           = var.launch_subnet_id
  cloud_asg_name             = var.cloud_asg_name
  cloud_asg_max_capacity     = var.cloud_asg_max_capacity
  cloud_asg_min_capacity     = var.cloud_asg_min_capacity
  cloud_asg_desired_capacity = var.cloud_asg_desired_capacity
  asg_lb_target              = module.loadbalancer.asg_lb_target
  launch_template_id         = module.launch_template.launch_template_id
}

# -------------------------------------------------------
#         AUTO SCALING POLICY MODULE
# -------------------------------------------------------
module "autoscaling_policy" {
  source = "./modules/autoscaling_policy"

  asg_name            = module.autoscaling_group.asg_name
  asg_scale_down_name = var.asg_scale_down_name
  asg_scale_up_name   = var.asg_scale_up_name
}


#--------------------------------------------------------
#      LOAD-BALANCER MODULE
#--------------------------------------------------------
module "loadbalancer" {
  source = "./modules/loadbalancer"

  env                      = var.env
  asg_alb_name             = var.asg_alb_name
  aws_lb_target_group_name = var.aws_lb_target_group_name
  asg_lb_sslpolicy         = var.asg_lb_sslpolicy
  aws_security_group_name  = module.security_group.aws_security_group_name
  launch_subnet_id         = var.launch_subnet_id
  vpc_id                   = var.vpc_id
  acm_certificate          = module.acm_ssl.acm_certificate
}
