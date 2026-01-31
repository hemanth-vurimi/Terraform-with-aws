variable "project_name" {}


variable "vpc_id" {}

variable "tags" {
    type = map(string)
    default = {}
}

variable "environment" {}