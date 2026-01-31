resource "aws_lb" "two-tier-lb" {
    name               = "${var.name_prefix}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = var.alb_sg_id
    subnets            = var.public_subnet_ids
    
    tags = merge(
        {
        Name = "${var.name_prefix}-alb"
        },
        var.alb_tags,
    )
  
}

# Create Target Group

resource "aws_lb_target_group" "two-tier-lb-tg" {
    name     = "${var.name_prefix}-alb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200-399"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = merge(
        {
        Name = "${var.name_prefix}-alb-tg"
        },
        var.alb_tags,
    )
  
}

# Create Listener

resource "aws_lb_listener" "two-tier-lb-listener" {
    load_balancer_arn = aws_lb.two-tier-lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.two-tier-lb-tg.arn
    }
  
}

