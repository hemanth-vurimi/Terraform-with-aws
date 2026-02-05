variable "cluster-name" {}


variable "cidr-block" {}

variable "env" {}

variable "igw-name" {}

variable "pub-subnet-count" {}

variable "pub-cidr-block" {
  type = list(string)
}

variable "pub-availability-zone" {
  type = list(string)
}

variable "pub-sub-name" {}

variable "pri-subnet-count" {}

variable "pri-cidr-block" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}
variable "pri-availability-zone" {
  type = list(string)
}

variable "pri-sub-name" {}

variable "eip-name" {}

variable "ngw-name" {}

variable "public-rt-name" {}
variable "private-rt-name" {}
variable "vpc-name" {}




# variable "cluster-name" {}

# variable "env" {}

variable "aws_cloudwatch_log_group_tags" {}



variable "aws_security_group_tags" {}



# variable "eks_cluster_sg_ingress_cidr_blocks" {
#   type = list(string)

# }

# variable "eks_node_sg_ingress_cidr_blocks" {
#   type = list(string)

# }


# variable "node_group_instance_types" {
#   type = list(string)

# }

# variable "desired_capacity" {
#   type = number

# }

# variable "min_size" {
#   type = number

# }

# variable "max_size" {
#   type = number

# }

variable "cluster_version" {}

variable "endpoint-private-access" {
  type = bool

}

variable "endpoint-public-access" {
  type = bool

}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}

# variable "log_types" {
#   type = list(string)

# }

variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_group_tags" {
  type    = map(string)
  default = {}
}



variable "aws_eks_node_group_tags" {
  type    = map(string)
  default = {}
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

variable "aws_iam_openid_connect_provider_tags" {
  type    = map(string)
  default = {}
}

variable "aws_eks_cluster_tags" {
  type    = map(string)
  default = {}
}

variable "aws_iam_role_tags" {
  type    = map(string)
  default = {}
}

variable "aws_iam_role_policy_tags" {
  type    = map(string)
  default = {}
}

variable "aws_iam_instance_profile_tags" {
  type    = map(string)
  default = {}
}


# variable "node_group_role_arn" {}

variable "is-eks-cluster-enabled" {}

variable "is_eks_role_enabled" {
  type = bool
}

variable "is_eks_nodegroup_role_enabled" {
  type = bool
}


