variable "vpc_cidr" {}

variable "public_subnet_cidr" {}

variable "private_subnet_cidr" {}
  
variable "public_subnet_count" {}

variable "private_subnet_count" {}

variable "public_subnet_az" {
    type = list(string)
}

variable "private_subnet_az" {
    type = list(string)
}

variable "environment" {}

variable "tags" {
    type = map(string)
    default = {}
}

