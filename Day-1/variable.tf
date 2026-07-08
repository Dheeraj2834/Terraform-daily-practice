variable "vpc-dev" {
  type = string
  description = "CIDR value for VPC"
  default = ""
}

variable "tag" {
  type = string
  description = "Tag value for VPC"
  default = ""
}

variable "subnet-public-1" {
  type = string
  description = "CIDR value for public subnet 1"
  default = ""
}

variable "subnet-public-2" {
  type = string
  description = "CIDR value for public subnet 2"
  default = ""
}

variable "tag-public-1" {
  type = string
  description = "Tag value for public subnet 1"
  default = ""
}

variable "tag-public-2" {
  type = string
  description = "Tag value for public subnet 2"
  default = ""
}

 variable "region" {
  type = string
  description = "AWS region"
  default = ""
 }

 variable "AZ-US-east-1a" {
  type = string
  description = "AWS availability zone"
  default = ""
 }

 variable "AZ-US-east-1b" {
  type = string
  description = "AWS availability zone"
  default = ""
 }
