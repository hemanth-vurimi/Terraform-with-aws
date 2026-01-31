resource "aws_vpc" "two-tier-vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    
    tags = merge(
        {
        Name = "${var.name_prefix}-vpc"
        },
        var.tags,
    )
  
}

resource "aws_subnet" "public_subnets" {
    count                   = length(var.public_subnets)
    vpc_id                  = aws_vpc.two-tier-vpc.id
    cidr_block              = var.public_subnets[count.index]
    availability_zone       = var.azs[count.index]
    map_public_ip_on_launch = true
    
    tags = merge(
        {
        Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
        },
        var.public_subnet_tags,
    )
  
}

resource "aws_subnet" "private_subnets" {
    count             = length(var.private_subnets)
    vpc_id            = aws_vpc.two-tier-vpc.id
    cidr_block        = var.private_subnets[count.index]
    availability_zone = var.azs[count.index]
    
    tags = merge(
        {
        Name = "${var.name_prefix}-private-subnet-${count.index + 1}"
        },
        var.private_subnet_tags,
    )
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.two-tier-vpc.id
    
    tags = {
        Name = "${var.name_prefix}-igw"
    }
  
}

resource "aws_route_table" "public-rt" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.two-tier-vpc.id
  
}

resource "aws_route" "public-route" {
    count = length(var.public_subnets)
    route_table_id         = aws_route_table.public-rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
    
   
  
}

resource "aws_route_table_association" "public-rt-assoc" {
    count = length(var.public_subnets)
    subnet_id      = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.public-rt[count.index].id
    
   
  
}


resource "aws_eip" "main" {
    count = length(var.public_subnets)
    domain = "vpc"
    tags = {
    Name = "nat-eip-az-${count.index + 1}"
  }
  depends_on = [ aws_internet_gateway.igw ]
  
}

resource "aws_nat_gateway" "nat-gateway" {
    count         = length(var.public_subnets)
    allocation_id = aws_eip.main[count.index].id
    subnet_id     = aws_subnet.public_subnets[count.index].id
    
    tags = {
        Name = "nat-gateway-az-${count.index + 1}"
    }
  
}

resource "aws_route_table" "private-rt" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.two-tier-vpc.id
  
}

resource "aws_route" "private-route" {
    count = length(var.private_subnets)
    route_table_id         = aws_route_table.private-rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat-gateway[count.index].id
  
}

resource "aws_route_table_association" "private-rt-assoc" {
    count = length(var.private_subnets)
    subnet_id      = aws_subnet.private_subnets[count.index].id
    route_table_id = aws_route_table.private-rt[count.index].id
  
}

