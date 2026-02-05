data "aws_ami" ubuntu{
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "pro-sg" {
  name = "pro-sg"
  description = "Security group for provisioning instance"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "pro-vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_pair # Replace with your key pair name
  security_groups = [aws_security_group.pro-sg.name]

  # provisioner "local-exec" {
  #   command = "echo Provisioning instance with IP: ${self.public_ip}"
    
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "echo '<h1>Provisioned by Terraform</h1>' | sudo tee /var/www/html/index.html"
    ]
    
  }
  connection {
    type = "ssh"
    user = var.username
    private_key = file(var.private_key_path)
    host = self.public_ip
  }

  tags = {
    Name = "Provisioning-Instance"
  }
  
}



