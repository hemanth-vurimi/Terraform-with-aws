terraform {
  required_version = "~> 1.13.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
  }
#   backend "s3" {
#     bucket       = "gloify-drift-bucket-2024"
#     region       = "ap-south-1"
#     key          = "drift/terraform.tfstate"
#     use_lockfile = true
#     profile      = "terraform-dev"
#     encrypt      = true
#   }

}




provider "aws" {

  region  = "ap-south-1"
  profile = "terraform-dev"

}


resource "aws_s3_bucket" "name" {
  bucket = "gloify-drift-bucket-2024"
  tags = {
    Name        = "gloify-drift-bucket-2024"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.name.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}



resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.name.id

  versioning_configuration {
    status = "Suspended"
  }
}




