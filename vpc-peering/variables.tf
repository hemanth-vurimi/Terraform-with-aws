variable "main_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "peer_vpc_cidr" {
  default = "10.1.0.0/16"

}

variable "main_vpc_subnet_cidr" {
  default = "10.0.1.0/24"

}

variable "peer_vpc_subnet-cidr" {
  default = "10.1.1.0/24"

}

variable "region_main" {
    default = "ap-south-1"
  
}
variable "region_peer" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
  
}
variable "main_key_name" {
  default = "vpc-peering-demo"
}

variable "peer_key_name" {
  default = "vpc-peering-demo"
  
}

# variable "main_sg_ingress_rules" {
#   description = "List of ingress rules for security group"
#   default  = [
#   {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   },
#   {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   },
#   {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "ICMP"
#     cidr_blocks = ["10.1.0.0/16"]
#   }
# ]

# }

# variable "peer_sg_ingress_rules" {
#   description = "List of ingress rules for security group"
#   default  = [
#   {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   },
#   {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   },
#   {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "ICMP"
#     cidr_blocks = ["10.0.0.0/16"]
#   }
# ]

# }



