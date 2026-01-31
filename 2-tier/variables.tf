variable "project_name" {}

variable "environment" {}

variable "public_subnet_count" {
  type = number

}

variable "private_subnet_count" {
  type = number

}

variable "vpc_cidr" {}

variable "public_subnet_cidr" {}

variable "private_subnet_cidr" {}

variable "public_subnet_az" {
  type = list(string)
}

variable "private_subnet_az" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

# End of 2-tier/variables.tf

variable "instance_type" {}

variable "key_name" {
  
}

  variable "notification_email" {
    
  }



variable "asg_desired_capacity" {

}

variable "asg_max_size" {

}
variable "asg_min_size" {

}

variable "scaling_cpu_high_threshold" {

}

