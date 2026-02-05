resource "aws_instance" "deploy-nginx" {
    
    ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    
    tags = {
        Name = "nginx-server"
        Env  = var.env
    }
    
    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                amazon-linux-extras install nginx1 -y
                systemctl start nginx
                systemctl enable nginx
                EOF
    
    depends_on = [aws_vpc.vpc]
  
}

output "name" {
    value = aws_instance.deploy-nginx.tags["Name"]
  
}

