

# output "alb_arn" {
#   description = "The ARN of the ALB"
#   value       = aws_lb.application-alb.arn
  
# }

# output "alb_sg_id" {
#   description = "The security group ID of the ALB"
#     value       = aws_security_group.alb-sg.id
  
# }

output "alb_tg_arn" {
  description = "The ARN of the ALB target group"
    value       = aws_alb_target_group.dev-alb-tg.arn  
}

