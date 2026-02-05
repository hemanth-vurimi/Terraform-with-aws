data "aws_ami" "ubuntu-ami" {
    most_recent = true
    
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    
    owners = ["099720109477"] # Canonical
  
}

resource "aws_security_group" "bastion-sg" {
    name = "bastion-sg-${var.env}"
    description = "Security group for bastion host"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

    
    }
  
}


resource "aws_instance" "deploy-nginx" {
    
    ami           = data.aws_ami.ubuntu-ami.id # Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    subnet_id     = element(aws_subnet.public-subnet.*.id, 0)
    key_name = "vpc-peering-demo"
    iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
    vpc_security_group_ids = [aws_security_group.bastion-sg.id]
    
    
    tags = {
        Name = "access-server"
        Env  = var.env
    }
    
    user_data = file("${path.module}/user-data.sh")
    
    depends_on = [aws_vpc.vpc]
  
}

output "name" {
    value = aws_instance.deploy-nginx.tags["Name"]
  
}

