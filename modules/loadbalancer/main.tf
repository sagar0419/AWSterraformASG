#----------------------------------------------------------------
#   LOADBLANCER FOR AUTO SCALING    
#----------------------------------------------------------------
resource "aws_lb" "asg_alb" {
  name               = var.asg_alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.aws_security_group_name}"]
  subnets            = var.launch_subnet_id

  tags = {
    name = var.asg_alb_name
    env = var.env
  }
}

#----------------------------------------------------------------
#   LISTENER FOR LOADBLANCER   
#----------------------------------------------------------------

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.asg_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.asg_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.asg_lb_sslpolicy
  certificate_arn   = var.acm_certificate 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_target_group.arn
  }
}

resource "aws_lb_target_group" "asg_target_group" {
  name     = var.aws_lb_target_group_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 3600
  }
}