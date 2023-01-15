#----------------------------------------------------------------
#   AWS ACM SSL FOR LOADBLANCER   
#----------------------------------------------------------------

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.fqdn_name}"
  validation_method = "DNS"

  validation_option {
    domain_name       = "*.${var.fqdn_name}"
    validation_domain = var.fqdn_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------------------------------
#   SSL VALIDATION   
#----------------------------------------------------------------

data "aws_route53_zone" "domain" {
  name         = var.fqdn_name
}

resource "aws_route53_record" "dns_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id
}

resource "aws_acm_certificate_validation" "acm_validate" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_record : record.fqdn]
}