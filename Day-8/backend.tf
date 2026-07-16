terraform {
  backend "s3" {
    bucket       = "dheerajdheeraj"
    key          = "D_vpc/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}