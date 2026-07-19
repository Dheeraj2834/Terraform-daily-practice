terraform {
  backend "s3" {
    bucket = "dheerajdheeraj"
    key    = "Network/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
  }
}