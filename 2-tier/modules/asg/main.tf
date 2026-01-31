resource "aws_launch_template" "app" {
    name_prefix   = "${var.environment}-app-lt-"
    image_id       = var.ami_id
    instance_type = var.instance_type
    
    network_interfaces {
            security_groups             = [var.instance_sg_id]
    }
    
    user_data = var.user_data
    
    tag_specifications {
        resource_type = "instance"
    
        tags = {
        Name        = "${var.environment}-app-instance"
        Environment = var.environment
        }
    }
  
}

resource "aws_autoscaling_group" "app_asg" {
    name                      = "${var.environment}-app-asg"
    max_size                  = var.asg_max_size
    min_size                  = var.asg_min_size
    desired_capacity          = var.asg_desired_capacity
    vpc_zone_identifier       = var.private_subnet_ids
    
    launch_template {
        id      = aws_launch_template.app.id
        version = "$Latest"
    }
    target_group_arns         = [var.alb_tg_arn]
    health_check_type         = "ELB"
    health_check_grace_period = 300

    tag {
        key                 = "Name"
        value               = "${var.environment}-app-asg-instance"
        propagate_at_launch = true
    }

    tag {
        key                 = "Environment"
        value               = var.environment
        propagate_at_launch = true
    }
  
    lifecycle {
        create_before_destroy = true
    }
}


# Simple Scaling Policy - Scale Out
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

# Simple Scaling Policy - Scale In

# resource "aws_autoscaling_policy" "scale_in" {
#   name                   = "scale-in"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.app_asg.name
# }

# Target Tracking Scaling Policy - CPU Utilization
resource "aws_autoscaling_policy" "target_tracking" {
  name                   = "target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
    alarm_name          = "${var.environment}-high-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 300
    statistic           = "Average"
    threshold           = 80
    
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.app_asg.name
    }
    
    alarm_actions = [aws_autoscaling_policy.scale_out.arn]
  
}

# resource "aws_cloudwatch_metric_alarm" "low_cpu" {
#     alarm_name          = "${var.environment}-low-cpu-alarm"
#     comparison_operator = "LessThanOrEqualToThreshold"
#     evaluation_periods  = 2
#     metric_name         = "CPUUtilization"
#     namespace           = "AWS/EC2"
#     period              = 300
#     statistic           = "Average"
#     threshold           = 30
    
#     dimensions = {
#         AutoScalingGroupName = aws_autoscaling_group.app_asg.name
#     }
    
#     alarm_actions = [aws_autoscaling_policy.scale_in.arn]
  
# }

