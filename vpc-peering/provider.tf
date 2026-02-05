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
  region  = var.region_main
  profile = "terraform-dev"
}

provider "aws" {
  # Configuration options
  region  = var.region_main
  profile = "terraform-dev"
  alias   = "main"
}

provider "aws" {
  region  = var.region_peer
  profile = "terraform-dev"
  alias   = "peer"

}