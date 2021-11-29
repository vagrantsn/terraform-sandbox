resource "aws_lb" "load_balancer" {
  name               = "wordpress-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_vpc.main.default_security_group_id]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target.arn
  }
}

resource "aws_lb_target_group" "lb_target" {
  name        = "wordpress-service"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    matcher = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }
}
