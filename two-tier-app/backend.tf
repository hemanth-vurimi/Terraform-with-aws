terraform {
  backend "s3" {
    bucket       = "testintg-sget-amer"
    region       = "ap-south-1"
    key          = "dev-env/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}
