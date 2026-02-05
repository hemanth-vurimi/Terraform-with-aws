# Environment
env          = "dev"
cluster-name = "dev-eks-cluster"

cluster_name = "dev-eks-cluster"

# VPC
vpc-name   = "dev-vpc"
cidr-block = "10.0.0.0/16"

# Internet Gateway
igw-name = "dev-igw"

# Public Subnets
pub-subnet-count = 2

pub-cidr-block = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

pub-availability-zone = [
  "ap-south-1a",
  "ap-south-1b"
]

pub-sub-name = "dev-public-subnet"

# Private Subnets
pri-subnet-count = 2

pri-cidr-block = [
  "10.0.101.0/24",
  "10.0.102.0/24"
]

pri-availability-zone = [
  "ap-south-1a",
  "ap-south-1b"
]

pri-sub-name = "dev-private-subnet"

# NAT Gateway & EIP
eip-name = "dev-nat-eip"
ngw-name = "dev-nat-gateway"

# Route Tables
public-rt-name  = "dev-public-rt"
private-rt-name = "dev-private-rt"

spot_instance_types = ["t3.micro", "t3a.micro", "t2.micro"]

desired_capacity_spot = 2

min_capacity_spot = 1

max_capacity_spot = 3

cluster_version = "1.33"

addons = [
  {
    name    = "vpc-cni"
    version = "v1.20.0-eksbuild.1"
  },
  {
    name    = "coredns"
    version = "v1.12.2-eksbuild.4"
  },
  {
    name    = "kube-proxy"
    version = "v1.33.0-eksbuild.2"
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.46.0-eksbuild.1"
  }
]

endpoint-private-access = true

endpoint-public-access = false

is-eks-cluster-enabled = true


# eks-sg = "sg-0abc1234def567890"

# IAM Roles

is_eks_role_enabled = true

is_eks_nodegroup_role_enabled = true

# On-Demand Instance Configuration

# desired_capacity_on_demand = 1
# min_capacity_on_demand     = 1  
# max_capacity_on_demand     = 2
# ondemand_instance_types    = [ "t3.micro", "t3a.micro", "t2.micro" ]

# Tags

aws_security_group_tags = {
  Environment = "dev"
  Project     = "eks-terraform"
}

aws_cloudwatch_log_group_tags = {
  Environment = "dev"
  Project     = "eks-terraform"
}

# eks_cluster_sg_ingress_cidr_blocks = ["0.0.0.0/0"]



















