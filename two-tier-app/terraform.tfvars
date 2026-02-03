vpc_cidr = "10.0.0.0/16"

public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]


name_prefix = "dev"

tags = {
  "managedBy" = "terraform"
}

project_name = "two-tier-app"
environment  = "dev"

public_subnet_tags = {
  "Tier" = "public"
}

private_subnet_tags = {
  "Tier" = "private"
}
    
key_name = "vpc-peering-demo"
instance_type    = "t3.micro"
desired_capacity = 1
min_size         = 1
max_size         = 3




