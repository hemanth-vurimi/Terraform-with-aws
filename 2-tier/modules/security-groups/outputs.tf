output "instance_sg_id" {
  description = "The ID of the instance security group"
  value       = aws_security_group.instance-sg.id
  
}

output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb-sg.id
  
}

