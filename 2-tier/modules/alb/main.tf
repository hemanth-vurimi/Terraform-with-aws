resource "aws_alb" "dev-alb" {
    name               = "${var.project_name}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.alb_sg_id]
    subnets            = var.public_subnet_ids

    tags = {
        Name = "${var.project_name}-alb",
        Environment = var.environment
    }
  
}

# Create Target Group

resource "aws_alb_target_group" "dev-alb-tg" {
    name     = "${var.project_name}-alb-tg"
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

    tags = {
        Name = "${var.project_name}-alb-tg",
        Environment = var.environment
    }
  
}

# Create Listener

resource "aws_alb_listener" "dev-alb-listener" {
    load_balancer_arn = aws_alb.dev-alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_alb_target_group.dev-alb-tg.arn
    }
  
}

