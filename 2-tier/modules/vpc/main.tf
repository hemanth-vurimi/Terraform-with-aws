resource "aws_vpc" "dev-vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "2-tier-vpc",
        Environment = var.environment
    }
  
}

# Create Public Subnet

resource "aws_subnet" "public_subnet" {
    count = var.public_subnet_count
    vpc_id                  = aws_vpc.dev-vpc.id
    cidr_block              = var.public_subnet_cidr[count.index]
    map_public_ip_on_launch = true
    availability_zone       = var.public_subnet_az[count.index]

    tags = {
        Name = "dev-public-subnet-${count.index + 1}",
        Environment = var.environment
    }
  
}

# Create Private Subnet

resource "aws_subnet" "private_subnet" {
    count = var.private_subnet_count
    vpc_id            = aws_vpc.dev-vpc.id
    cidr_block        = var.private_subnet_cidr[count.index]
    availability_zone = var.private_subnet_az[count.index]

    tags = {
        Name = "dev-private-subnet-${count.index + 1}",
        Environment = var.environment
    }
  
}

# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.dev-vpc.id

    tags = {
        Name = "dev-igw",
        Environment = var.environment
    }
  
}

# Create Public Route Table

resource "aws_route_table" "public_rt" {
    count = var.public_subnet_count
    vpc_id = aws_vpc.dev-vpc.id

    tags = {
        Name = "dev-public-rt",
        Environment = var.environment
    }
  
}

# Create Route to Internet Gateway in Public Route Table

resource "aws_route" "public-rt" {
    count = var.public_subnet_count
    route_table_id = aws_route_table.public_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
}

# Associate Public Subnet with Public Route Table

resource "aws_route_table_association" "public_rt_assoc" {
    count = var.public_subnet_count
    subnet_id      = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt[count.index].id
  
}

# Create NAT Gateway in Public Subnet

resource "aws_eip" "main" {
  count  = var.private_subnet_count
  domain = "vpc"

  tags = {
    Name = "nat-eip-az-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
    count = var.private_subnet_count
    allocation_id = aws_eip.main[count.index].id
    subnet_id     = aws_subnet.public_subnet[count.index].id

    tags = {
        Name = "dev-nat-gw-az-${count.index + 1}",
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.igw]
  
}

# Create Private Route Table

resource "aws_route_table" "private_rt" {
    count = var.private_subnet_count
    vpc_id = aws_vpc.dev-vpc.id

    tags = {
        Name = "dev-private-rt",
        Environment = var.environment
    }
  
}

# Create Route to NAT Gateway in Private Route Table

resource "aws_route" "private-rt" {
    count = var.private_subnet_count
    route_table_id = aws_route_table.private_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  
}

# Associate Private Subnet with Private Route Table

resource "aws_route_table_association" "private_rt_assoc" {
    count = var.private_subnet_count
    subnet_id      = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rt[count.index].id
  
}

