output "asg_alb_dns" {
  value = aws_lb.asg_alb.dns_name
}
output "asg_alb_zone" {
  value = aws_lb.asg_alb.zone_id
}

output "asg_lb_target" {
  value = aws_lb_target_group.asg_target_group.arn
}