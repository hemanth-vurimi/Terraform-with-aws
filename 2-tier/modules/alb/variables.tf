variable "project_name" {}

variable "vpc_id" {}

variable "tags" {
    type = map(string)
    default = {}
}

variable "environment" {}

variable "alb_sg_id" {}

variable "public_subnet_ids" {
    type = list(string)
  
}