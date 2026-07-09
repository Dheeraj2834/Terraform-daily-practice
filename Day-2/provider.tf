provider "aws" {
  
}

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.53.0"
    }
  }
}

terraform {
  required_version = ">= 1.15.0"
}