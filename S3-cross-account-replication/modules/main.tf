resource "aws_instance" "test_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
    security_groups = [aws_security_group.test-sg.name]
    # key_name = var.key_name

  tags = {
    Name = "${var.environment}-test-server"
  }
  
}

resource "aws_security_group" "test-sg" {
    name        = "${var.environment}-test-sg"
    description = "Security group for test server"
    vpc_id      = var.vpc_id
    
    tags = {
        Name = "${var.environment}-test-sg"
    }
  
}



output "instance_id" {
    value = aws_instance.test_server.id
  
}