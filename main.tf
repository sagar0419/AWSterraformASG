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
#     region = "us-west-2"
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
#      AUTO SCALING MODULE
#--------------------------------------------------------
module "auto_scaling" {
  source = "./modules/auto_scaling"

  ami_name                   = var.ami_name
  ami_value                  = var.ami_value
  vpc_id                     = var.vpc_id
  launch_conf_name           = var.launch_conf_name
  launch_conf_instance_type  = var.launch_conf_instance_type
  launch_conf_sg             = var.launch_conf_sg
  launch_conf_key_name       = var.launch_conf_key_name
  launch_subnet_id           = var.launch_subnet_id
  cloud_asg_name             = var.cloud_asg_name
  cloud_asg_max_capacity     = var.cloud_asg_max_capacity
  cloud_asg_min_capacity     = var.cloud_asg_min_capacity
  cloud_asg_desired_capacity = var.cloud_asg_desired_capacity
  asg_lb_target              = module.loadbalancer.asg_lb_target
}

#--------------------------------------------------------
#      LOAD-BALANCER MODULE
#--------------------------------------------------------
module "loadbalancer" {
  source = "./modules/loadbalancer"

  asg_alb_name             = var.asg_alb_name
  aws_lb_target_group_name = var.aws_lb_target_group_name
  asg_lb_sslpolicy         = var.asg_lb_sslpolicy
  launch_conf_sg           = var.launch_conf_sg
  launch_subnet_id         = var.launch_subnet_id
  vpc_id                   = var.vpc_id
  acm_certificate          = module.acm_ssl.acm_certificate
}
