resource "aws_lb" "k3s-master-lb" {
  name               = "k3s-master-tcp-lb"
  load_balancer_type = "network"
  internal           = "false" #tfsec:ignore:aws-elb-alb-not-public
  subnets            = var.vpc_subnets

  enable_cross_zone_load_balancing = true
}

resource "aws_autoscaling_attachment" "target" {

  depends_on = [
    aws_autoscaling_group.k3s_masters_asg,
    aws_lb_target_group.k3s-master-tg
  ]

  autoscaling_group_name = aws_autoscaling_group.k3s_masters_asg.name
  lb_target_group_arn   = aws_lb_target_group.k3s-master-tg.arn
}

###############
###  RULES  ###
###############

resource "aws_lb_listener" "k3s-master-listener" {
  load_balancer_arn = aws_lb.k3s-master-lb.arn

  protocol = "TCP"
  port     = 6443

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s-master-tg.arn
  }
}

resource "aws_lb_target_group" "k3s-master-tg" {
  port     = 6443
  protocol = "TCP"
  vpc_id   = var.vpc_id


  depends_on = [
    aws_lb.k3s-master-lb
  ]

  health_check {
    protocol = "TCP"
  }

  lifecycle {
    create_before_destroy = true
  }
}
