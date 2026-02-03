terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

provider "aws" {
  alias  = "dest"
  region = "us-west-1"
    
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical

# }


# data "aws_vpc" "selected" {

#   default = true
# }

# data "aws_availability_zones" "azs" {
#     state = "available"
  
# }

# module "ec2" {
#   source = "./modules"

#   environment   = "dev"
#   instance_type = "t2.micro"
#   ami_id        = data.aws_ami.ubuntu.id
#   vpc_id        = data.aws_vpc.selected.id
#   }

# resource "aws_ebs_volume" "test_volume" {
#   availability_zone = data.aws_availability_zones.azs.names[0]
#   size              = 8

#   tags = {
#     Name = "test-volume"
#   }
  
# }

# resource "aws_volume_attachment" "test_attachment" {
#   device_name = "/dev/xvdf"
#   volume_id   = aws_ebs_volume.test_volume.id
#   instance_id = module.ec2.instance_id
  
# }



# resource "random_id" "s3" {
#     byte_length = 4
  
# }

resource "aws_s3_bucket" "bucket" {
  bucket = "tf-test-bucket-${random_id.s3.hex}"

  tags = {
    Name        = "tf-test-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_s3_account_public_access_block" "block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  
}


resource "aws_s3_bucket" "cross" {
    bucket = "tf-cross-account-bucket-${random_id.s3.hex}"
    provider = aws.dest
    
    tags = {
        Name        = "tf-cross-account-bucket"
        Environment = "Dev"
    }


}

resource "random_id" "s3" {
    byte_length = 4
}

resource "aws_s3_bucket_versioning" "cross_versioning" {
    bucket = aws_s3_bucket.cross.id
    provider = aws.dest
    
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_account_public_access_block" "cross_block" {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  
}

resource "aws_iam_role" "s3_role" {
  name = "ec2-s3-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Read from source
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.bucket.arn
      },

      # Write to destination
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${aws_s3_bucket.cross.arn}/*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3_role_attachment" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

resource "aws_s3_bucket_policy" "cross-policy" {
    bucket = aws_s3_bucket.cross.id
    provider = aws.dest
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            AWS = aws_iam_role.s3_role.arn
            }
            Action = [
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags"
            ]
            Resource = "${aws_s3_bucket.cross.arn}/*"
        }
        ]
    })
  
}


resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.bucket.id
  role  = aws_iam_role.s3_role.arn

  rule {
    id     = "cross-region-replication"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.cross.arn
      storage_class = "STANDARD"
    }
  }
}


resource "aws_s3_object" "example_object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "./file.txt"
  content = "This is an example object to demonstrate S3 replication."
  depends_on = [ aws_s3_bucket.bucket ]
  
}





# output "s3_bucket_name" {
#   value = aws_s3_bucket.bucket.id
# }
