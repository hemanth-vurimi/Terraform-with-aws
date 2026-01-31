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

variable "azs" {
  description = "List of availability zones"
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
  default     = {
    Terraform = "true",
    ManagedBy  = "Terraform"
  }
  
}

