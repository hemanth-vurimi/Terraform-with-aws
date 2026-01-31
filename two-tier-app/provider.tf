terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region  = "ap-south-1"
  profile = "terraform-dev"
}