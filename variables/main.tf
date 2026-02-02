terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

provider "aws" {
  # Configuration options
    region  = "ap-south-1"
    profile = "terraform-dev"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
    bucket_name = "${var.bucket_name}-${var.environment}-${random_string.suffix.result}"
    region      = "ap-south-1"
}

resource "aws_s3_bucket" "drift_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}


resource "aws_security_group" "allow_tls" {
  name        = "${var.environment}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  from_port         = 443
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
    cidr_ipv4         = "0.0.0.0/0"

  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "allow_redis" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = "${aws_security_group.allow_tls.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "demo-server" {

    ami           = "ami-0d176f79571d18a8f" # Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    security_groups = [aws_security_group.allow_tls.name]
    
    tags = {
        Name = "${var.environment}-server"
    } 
}