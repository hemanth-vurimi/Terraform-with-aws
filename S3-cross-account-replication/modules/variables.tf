variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  
}

variable "instance_type" {
    description = "The type of instance to use"
    type        = string
  
}

variable "environment" {
    description = "The environment for the resources (e.g., dev, prod)"
    type        = string
  
}

variable "vpc_id" {
    description = "The VPC ID where resources will be deployed"
    type        = string
  
}

# variable "key_name" {
#     description = "The name of the key pair to use for the EC2 instance"
#     type        = string
  
# }


