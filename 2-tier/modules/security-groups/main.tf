resource "aws_security_group" "instance-sg" {
    name        = "${var.project_name}-instance-sg"
    description = "Security group for EC2 instances"
    vpc_id      = var.vpc_id

    tags = {
        Name = "${var.project_name}-instance-sg",
        Environment = var.environment
    }
  
}

# Ingress rule to allow HTTP traffic from anywhere

resource "aws_security_group_rule" "ingress-allow" {
    security_group_id = aws_security_group.instance-sg.id
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    source_security_group_id = aws_security_group.alb-sg.id
  
}

# Egress rule to allow all outbound traffic

resource "aws_security_group_rule" "egress-allow" {
    security_group_id = aws_security_group.instance-sg.id
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]

  
}

resource "aws_security_group" "alb-sg" {
    name        = "${var.project_name}-alb-sg"
    description = "Security group for ALB"
    vpc_id      = var.vpc_id

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


    tags = {
        Name = "${var.project_name}-alb-sg",
        Environment = var.environment
    }
  
}

# Ingress rule to allow HTTP traffic from anywhere to ALB

