resource "aws_lb" "k3s-public-lb" {
  name               = "k3s-public-tcp-lb"
  load_balancer_type = "network"
  internal           = "false" ## TODO: make internal
  subnets            = var.vpc_subnets

  enable_cross_zone_load_balancing = true
}

resource "aws_autoscaling_attachment" "public_target" {

  depends_on = [
    aws_autoscaling_group.k3s_masters_asg,
    aws_lb_target_group.k3s-public-tg
  ]

  autoscaling_group_name = aws_autoscaling_group.k3s_masters_asg.name
  lb_target_group_arn    = aws_lb_target_group.k3s-public-tg.arn
}

resource "aws_lb_listener" "k3s-public-listener" {
  load_balancer_arn = aws_lb.k3s-public-lb.arn

  protocol = "TCP"
  port     = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s-public-tg.arn
  }
}

resource "aws_lb_target_group" "k3s-public-tg" {
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id


  depends_on = [
    aws_lb.k3s-public-lb
  ]

  health_check {
    protocol = "TCP"
  }

  lifecycle {
    create_before_destroy = true
  }
}
