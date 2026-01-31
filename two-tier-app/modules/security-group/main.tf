resource "aws_security_group" "alb-sg" {
    name = "${var.project_name}-alb-sg-${var.environment}"
    description = "Security group for ALB"
    vpc_id = var.vpc_id

  
}

resource "aws_security_group_rule" "alb-ingress-sg-rule" {
    security_group_id = aws_security_group.alb-sg.id
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    
}

resource "aws_security_group_rule" "alb-egress-sg-rule" {
    security_group_id = aws_security_group.alb-sg.id
    type              = "egress"
    from_port         = 0  
    to_port           = 0
    protocol          = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  
}

resource "aws_security_group" "instance-sg" {
    name        = "${var.project_name}-instance-sg-${var.environment}"
    description = "Security group for EC2 instances"
    vpc_id      = var.vpc_id
  
}

resource "aws_security_group_rule" "instance-ingress-sg-rule" {
    security_group_id = aws_security_group.instance-sg.id
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    source_security_group_id = aws_security_group.alb-sg.id
  
}

resource "aws_security_group_rule" "instance-egress-sg-rule" {
    security_group_id = aws_security_group.instance-sg.id
    type              = "egress"  
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  
}





