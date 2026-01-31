variable "environment" {
  
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling group"
  type        = number
  default     = 1
  
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling group"
  type        = number
  default     = 3
  
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group"
  type        = number
  default     = 2
  
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Auto Scaling group"
  type        = list(string)
  
}

variable "instance_sg_id" {
  
}

variable "target_group_arns" {
  description = "ARN of the Application Load Balancer Target Group"
  type        = list(string)
  
}

variable "alb_tg_arn" {
  description = "ARN of the Application Load Balancer Target Group"
  type        = string
  
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling group"
  type        = string
  default     = "t3.micro"
  
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  
}

variable "key_name" {
  description = "Key pair name for SSH access to the instances"
  type        = string
  default     = ""
  
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "app"
  
}