data "aws_ami" "example" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = base64encode(
    templatefile("${path.module}/scripts/user_data.sh", {
      env = var.environment
    })
  )
}





module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  public_subnet_az     = var.public_subnet_az
  private_subnet_az    = var.private_subnet_az
  environment          = var.environment
  tags                 = var.tags


}

module "security_groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  environment  = var.environment
  tags         = var.tags

}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  environment       = var.environment
  tags              = var.tags
}

module "asg" {
  source                     = "./modules/asg"
  environment                = var.environment
  project_name               = var.project_name
  instance_sg_id             = module.security_groups.instance_sg_id
  vpc_id                     = module.vpc.vpc_id
  alb_sg_id                  = module.security_groups.alb_sg_id
  ami_id                     = data.aws_ami.example.id
  instance_type              = var.instance_type
  alb_tg_arn                 = module.alb.alb_tg_arn
  user_data                  = local.user_data
  private_subnet_ids         = module.vpc.private_subnet_ids
  asg_desired_capacity       = var.asg_desired_capacity
  asg_max_size               = var.asg_max_size
  asg_min_size               = var.asg_min_size
  key_name                   = var.key_name
  scaling_cpu_high_threshold = var.scaling_cpu_high_threshold
  tags                       = var.tags

}

resource "aws_sns_topic" "high_cpu" {
  name = "${var.project_name}-high-cpu-topic"

  
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.high_cpu.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "${var.project_name}-high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.scaling_cpu_high_threshold
  alarm_description   = "This metric monitors high CPU utilization"
  dimensions = {
    AutoScalingGroupName = module.asg.asg_name
  }
  alarm_actions       = [aws_sns_topic.high_cpu.arn]
  
}

resource "aws_sns_topic_policy" "high_cpu_policy" {
  arn    = aws_sns_topic.high_cpu.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action = "SNS:Publish"
        Resource = aws_sns_topic.high_cpu.arn
      }
    ]
  })
  
}



