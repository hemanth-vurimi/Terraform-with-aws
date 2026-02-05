resource "aws_instance" "server" {
  ami           = "ami-0912f71e06545ad88" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  count         = var.instance_count
  instance_type = var.environment == "prod" ? "t3.micro" : "t2.small"
  security_groups = [aws_security_group.dynamic-sg.name]
  lifecycle {
    # prevent_destroy = true
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-demo-server"
  }

}

resource "aws_security_group" "dynamic-sg" {
    name        = "${var.environment}-dynamic-sg"

    dynamic "ingress" {
      for_each = var.ingress_rules
      content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
      
    }

    egress { 
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "${var.environment}-dynamic-sg"
    }
  
}

locals {
  instance_ids = aws_instance.server[*].id
  all_private_ips = aws_instance.server[*].private_ip

}

output "instance_ids" {
  value = {
    instance_ids   = local.instance_ids
    private_ips    = local.all_private_ips
  }
}
