variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"

}

variable "instance_count" {
  description = "Number of instances to deploy"
  type        = number
  default     = 1

}

# variable "instance_type" {
#   description = "The type of instance to deploy"
#   type        = string

# }

variable "environment" {
  description = "The environment to deploy resources in"
  type        = string
  default     = "dev"

}

variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

}

variable "s3_bucket_base_name" {
  description = "Base name for the S3 bucket"
  type        = string
  
}

variable "default_tags" {
  type = map(string)
  default = {
    company    = "TechCorp"
    managed_by = "terraform"
  }
}

variable "environment_tags" {
  type = map(string)
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

variable "allowed_ports" {
  default = "80,443,8080,3306"
}

variable "instance_type" {
  default = "t2.micro"
  
  validation {
    condition     = length(var.instance_type) >= 2 && length(var.instance_type) <= 20
    error_message = "Instance type must be between 2 and 20 characters"
  }
  
  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must start with t2 or t3"
  }
}

variable "s3_name" {

  default = "daily_backup"
  validation {
    condition     = endswith(var.s3_name, "_backup")
    error_message = "Backup name must end with '_backup'"
  }
}

variable "credential" {
  default   = "xyz123"
  sensitive = true

}

variable "user_locations" {
  default = ["ap-south-1","us-east-1", "us-west-2", "us-east-1"]
  
}

variable "default_locations" {
  default = ["us-east-1", "us-west-2"]
  
}