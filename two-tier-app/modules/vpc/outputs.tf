output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.two-tier-vpc.id
  
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public_subnets[*].id
  
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private_subnets[*].id
  
}

output "subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

