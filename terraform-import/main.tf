# resource "aws_instance" "import-server" {
#     provider = aws.use1
#     ami  =  "ami-0ecb62995f68bb549"
#     instance_type = "t2.micro"
#     key_name = "vpc-peering-demo"
#     iam_instance_profile = "SSM"
#     vpc_security_group_ids = [ aws_security_group.import-sg.id ]

#     lifecycle {
#         ignore_changes = [tags]
#     }


# }

# resource "aws_security_group" "import-sg" {
#   provider = aws.use1

#   name   = "import-sg"
#   description = "import-sg"

#   vpc_id = "vpc-0949441fa3d660eee"
# }

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


resource "aws_instance" "test-instance" {
  ami           = data.aws_ami.ubuntu-ami.id
  instance_type = "t2.micro"
  key_name      = "vpc-peering-demo"

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.test-sg.id]

#   provisioner "remote-exec" {
#     inline = [
#       "sudo snap install aws-cli --classic",
#       "aws --version",
#       "aws s3 ls"
#     ]
#   }

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("vpc-peering-demo.pem")
#     host        = self.public_ip
#   }
 }



resource "aws_security_group" "test-sg" {
  name   = "test-sg"
  description = "test-sg"

  # vpc_id = "vpc-0949441fa3d660eee"  

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket-terraform-1234567890"
  depends_on = [ aws_instance.test-instance ]
  tags = {
    Name        = "test-bucket"
    Environment = "Dev"
  }  

  
}

resource "aws_s3_bucket_public_access_block" "test-bucket-public-access-block" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "test-bucket-versioning" {
  bucket = aws_s3_bucket.test_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}



resource "aws_iam_policy" "s3_access_policy" {
  name = "ec2-s3-bucket-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.test_bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.test_bucket.arn}/*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}


resource "aws_s3_bucket_policy" "test-bucket-policy" {
  bucket = aws_s3_bucket.test_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2RoleOnly"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.ec2_s3_role.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.test_bucket.arn,
          "${aws_s3_bucket.test_bucket.arn}/*"
        ]
      }
    ]
  })
}

output "instance_public_ip" {
  value = aws_instance.test-instance.public_ip
  
}










