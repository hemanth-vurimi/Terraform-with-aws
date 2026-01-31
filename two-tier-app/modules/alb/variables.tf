variable "alb_sg_id" {
    description = "List of security group IDs to associate with the ALB"
    type        = list(string)
  
}


variable "name_prefix" {
    description = "Prefix for naming resources"
    type        = string
  
}

variable "tags" {
    description = "Additional tags for all resources"
    type        = map(string)
    default     = {}
  
}   

variable "project_name" {
    description = "The name of the project"
    type        = string
  
}

variable "environment" {
    description = "The deployment environment (e.g., dev, staging, prod)"
    type        = string
  
}

variable "alb_tags" {
  
}

variable "vpc_id" {
    description = "The ID of the VPC where the ALB will be deployed"
    type        = string
  
}

variable "public_subnet_ids" {
    description = "List of public subnet IDs for the ALB"
    type        = list(string)
  
}





