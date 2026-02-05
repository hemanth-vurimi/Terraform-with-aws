

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.main_vpc_cidr
  provider = aws.main
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "Main_VPC"
  }

}

resource "aws_vpc" "peer_vpc" {
  cidr_block           = var.peer_vpc_cidr
    provider = aws.peer
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Peer_VPC"
  }

}

resource "aws_subnet" "main_vpc_subnet" {
    provider = aws.main
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.main_vpc_subnet_cidr
  availability_zone = data.aws_availability_zones.main-azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Main_VPC_Subnet"
  }
}

resource "aws_subnet" "peer_vpc_subnet" {
    provider = aws.peer
  vpc_id            = aws_vpc.peer_vpc.id
  cidr_block        = var.peer_vpc_subnet-cidr
  availability_zone = data.aws_availability_zones.peer-azs.names[0]
    map_public_ip_on_launch = true

  tags = {
    Name = "Peer_VPC_Subnet"
  }
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.peer_vpc.id
  vpc_id      = aws_vpc.main_vpc.id

  peer_region = var.region_peer

  tags = {
    Name = "VPC_Peering_Connection"
  }
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept               = true
  provider                  = aws.peer

  tags = {
    Name = "VPC_Peering_Accepter"
  }
}

resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  provider = aws.main

  tags = {
    Name = "Main_VPC_IGW"
  }

}

resource "aws_internet_gateway" "peer_vpc_igw" {
  vpc_id = aws_vpc.peer_vpc.id
    provider = aws.peer

  tags = {
    Name = "Peer_VPC_IGW"
  }

}

resource "aws_route_table" "main_vpc_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  provider = aws.main

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_igw.id
  }

  tags = {
    Name = "Main_VPC_Route_Table"
  }
}

resource "aws_route_table" "peer_vpc_route_table" {
  vpc_id = aws_vpc.peer_vpc.id
  provider = aws.peer   

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.peer_vpc_igw.id
  }

  tags = {
    Name = "Peer_VPC_Route_Table"
  }
}

resource "aws_route" "main_to_peer_route" {
   provider = aws.main
  route_table_id            = aws_route_table.main_vpc_route_table.id
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  depends_on = [ aws_vpc_peering_connection_accepter.accepter ]
}

resource "aws_route" "peer_to_main_route" {
    provider = aws.peer
  route_table_id            = aws_route_table.peer_vpc_route_table.id
  destination_cidr_block    = var.main_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id

    depends_on = [ aws_vpc_peering_connection_accepter.accepter ]
}

resource "aws_security_group" "main_sg" {
  provider    = aws.main
  name        = "main-vpc-sg"
  description = "Security group for Primary VPC instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.peer_vpc_cidr]
  }

  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.peer_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "main-VPC-SG"
    Environment = "Demo"
  }
}

resource "aws_security_group" "peer-sg" {
  provider    = aws.peer
  name        = "peer-vpc-sg"
  description = "Security group for Primary VPC instance"
  vpc_id      = aws_vpc.peer_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.main_vpc_cidr]
  }

  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.main_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "peer-VPC-SG"
    Environment = "Demo"
  }
}

resource "aws_instance" "main_vpc_instance" {
  ami           =  data.aws_ami.main_ami.id # Amazon Linux 2 AMI (for ap-south-1)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_vpc_subnet.id
  vpc_security_group_ids = [ aws_security_group.main_sg.id ]
  key_name = var.main_key_name
  tags = {
    Name = "Main_VPC_Instance"
  }
  
}

resource "aws_instance" "peer_vpc_instance" {
    provider = aws.peer
  ami           =  data.aws_ami.peer_ami.id # Amazon Linux 2 AMI (for us-east-1)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.peer_vpc_subnet.id
    vpc_security_group_ids = [ aws_security_group.peer-sg.id ]
    key_name = var.peer_key_name

  tags = {
    Name = "Peer_VPC_Instance"
  }
  
}

resource "aws_route_table_association" "main_vpc_rta" {
  provider = aws.main
  subnet_id      = aws_subnet.main_vpc_subnet.id
  route_table_id = aws_route_table.main_vpc_route_table.id
}

resource "aws_route_table_association" "peer_vpc_rta" {
    provider = aws.peer
  subnet_id      = aws_subnet.peer_vpc_subnet.id
  route_table_id = aws_route_table.peer_vpc_route_table.id
}







