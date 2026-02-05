variable "env" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_role_arn" {
  type = string
}

variable "node_group_role_arn" {
  type = string
}

variable "endpoint_private_access" {
  type = bool
}

variable "endpoint_public_access" {
  type = bool
}

variable "eks_cluster_sg_ingress_cidr_blocks" {
  type = list(string)
}

variable "eks_node_sg_ingress_cidr_blocks" {
  type = list(string)
}

variable "spot_instance_types" {
  type = list(string)
}

variable "desired_capacity_spot" {
  type = number
}

variable "min_capacity_spot" {
  type = number
}

variable "max_capacity_spot" {
  type = number
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = []
}

variable "aws_security_group_tags" {
  type    = map(string)
  default = {}
}

variable "aws_eks_cluster_tags" {
  type    = map(string)
  default = {}
}

variable "aws_eks_node_group_tags" {
  type    = map(string)
  default = {}
}

variable "aws_cloudwatch_log_group_tags" {
  type    = map(string)
  default = {}
}
