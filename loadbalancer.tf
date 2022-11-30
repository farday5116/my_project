# Create ALB.

resource "aws_lb" "app" {
  name               = var.app
  subnets            = module.vpc.public_subnets
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_loadbalancer.id]

  tags = {
    Name             = var.app_lb
  }
}

resource "aws_lb_target_group" "app" {
  name        = var.app
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id
  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
  health_check {
    interval            = "30"
    path                = "/"
    port                = "80"
    timeout             = "3"
    unhealthy_threshold = "2"
    healthy_threshold   = "2"
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"
  # If you wish to enable HTTPS using AWS ACM, then uncomment the below, and turn the above protocol to HTTPS.
  #certificate_arn    = aws_acm_certificate.cert.arn
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  #depends_on        = [aws_acm_certificate.cert]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
