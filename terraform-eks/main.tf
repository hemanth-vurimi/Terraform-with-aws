locals {
  cluster_name = var.cluster-name
}

module "vpc" {
  source = "./modules/vpc"

  name_prefix     = var.cluster_name
  vpc_cidr        = var.vpc_cidr
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  # Required tags for EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
    Project     = "EKS-Day20"
  }
}

module "iam" {
  source = "./modules/iam"

  cluster-name = var.cluster-name
  env          = var.env
}

module "eks_cluster" {
  source = "./modules/eks"

  env                = var.env
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  cluster_role_arn    = module.iam.eks_role_arn
  node_group_role_arn = module.iam.eks_nodegroup_role_arn

  endpoint_private_access = true
  endpoint_public_access  = false

  eks_cluster_sg_ingress_cidr_blocks = ["0.0.0.0/0"]
  eks_node_sg_ingress_cidr_blocks    = ["0.0.0.0/0"]

  spot_instance_types   = ["t3.medium"]
  desired_capacity_spot = 2
  min_capacity_spot     = 1
  max_capacity_spot     = 3

  addons = var.addons
}




