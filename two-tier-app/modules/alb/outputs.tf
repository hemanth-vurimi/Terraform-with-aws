output "alb_tg_arn" {
    description = "The ARN of the ALB target group"
    value       = aws_lb_target_group.two-tier-lb-tg.arn
  
}