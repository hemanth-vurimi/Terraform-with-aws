data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    
    owners = ["099720109477"] # Canonical
    
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
  
}


module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = data.aws_availability_zones.available.names
  name_prefix     = var.name_prefix
  public_subnet_tags = var.public_subnet_tags
    private_subnet_tags = var.private_subnet_tags

  tags = var.tags

}

module "security_groups" {
  source = "./modules/security-group"
    project_name = var.project_name
    vpc_id       = module.vpc.vpc_id
    environment  = var.environment  
}

module "alb" {
    source = "./modules/alb"

    project_name      = var.project_name
    vpc_id            = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnets
    alb_sg_id         = [module.security_groups.alb-sg_id]
    environment       = var.environment
    alb_tags = var.tags
    name_prefix = var.name_prefix

  
}


module "asg" {
  source = "./modules/asg"

    environment      = var.environment
    ami_id           = data.aws_ami.ubuntu.id
    instance_type    = var.instance_type
    key_name         = var.key_name
    desired_capacity = var.desired_capacity
    min_size         = var.min_size
    max_size         = var.max_size
    alb_tg_arn = module.alb.alb_tg_arn
    private_subnet_ids = module.vpc.private_subnets
    instance_sg_id = module.security_groups.instance-sg
    target_group_arns = [module.alb.alb_tg_arn]

  
}