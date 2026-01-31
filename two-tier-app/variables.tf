variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string

}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)

}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)

}


variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string

}

variable "public_subnet_tags" {
  description = "Additional tags for public subnets"
  type        = map(string)
  default     = {}

}

variable "private_subnet_tags" {
  description = "Additional tags for private subnets"
  type        = map(string)
  default     = {}

}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default = {
    Terraform = "true",
    ManagedBy = "Terraform"
  }

}

variable "project_name" {
  
}

variable "environment" {
  
}

variable "key_name" {
  description = "The name of the key pair to use for EC2 instances"
  type        = string
  
}

variable "instance_type" {
  description = "The instance type for EC2 instances"
  type        = string
  default     = "t3.micro"
  
}

variable "desired_capacity" {
  description = "The desired number of instances in the Auto Scaling group"
  type        = number
  default     = 2
  
}

variable "min_size" {
  description = "The minimum number of instances in the Auto Scaling group"
  type        = number
  default     = 2
  
}

variable "max_size" {
  description = "The maximum number of instances in the Auto Scaling group"
  type        = number
  default     = 4
  
}

