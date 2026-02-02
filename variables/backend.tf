terraform {
  backend "s3" {
    bucket   = "testintg-sget-amer"
    key      = "dev/terraform.tfstate"
    region   = "ap-south-1"
    #profile  = "terraform-dev"
    use_lockfile = true
  }
}