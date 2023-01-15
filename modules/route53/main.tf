#----------------------------------------------------------------
#   DOMAIN FOR LOADBLANCER SSL   
#----------------------------------------------------------------
data "aws_route53_zone" "domain" {
  name         = var.fqdn_name
}

resource "aws_route53_record" "asg_lb_record" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.domain_name_asg
  type    = "A"

  alias {
    name                   = var.asg_alb_dns
    zone_id                = var.asg_alb_zone
    evaluate_target_health = true
  }
}