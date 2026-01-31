variable "environment" {}

variable "project_name" {}

variable "instance_sg_id" {
  
}

variable "vpc_id" {}

variable "tags" {
    type = map(string)
    default = {}
}

variable "alb_sg_id" {}

variable "ami_id" {
  
}

variable "instance_type" {}


variable "alb_tg_arn" {
  
}

variable "user_data" {}

variable "private_subnet_ids" {
    type = list(string)
  
}

variable "asg_desired_capacity" {
  
}

variable "asg_max_size" {
  
}

variable "asg_min_size" {
  
}

variable "key_name" {}  

variable "scaling_cpu_high_threshold" {
  
}
