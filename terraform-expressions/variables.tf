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