output "alb-sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb-sg.id
  
}

output "instance-sg" {
  description = "The ID of the EC2 instance security group"
  value       = aws_security_group.instance-sg.id
  
}