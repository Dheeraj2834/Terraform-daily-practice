terraform {
  backend "s3" {
    bucket = "dheerajdheeraj"
    key    = "rds/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
  }
}