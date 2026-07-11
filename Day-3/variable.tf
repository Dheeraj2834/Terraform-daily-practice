variable "aws_region" {
  default = "us-east-1"
}

variable "app_vpc_name" {
  default = "Terraform-VPC"
}

variable "app_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1a_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_1b_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_1a_cidr" {
  default = "10.0.3.0/24"
}

variable "private_subnet_1b_cidr" {
  default = "10.0.4.0/24"
}

variable "public_subnet_1a_az" {
  default = "us-east-1a"
}

variable "public_subnet_1b_az" {
  default = "us-east-1b"
}

variable "private_subnet_1a_az" {
  default = "us-east-1a"
}

variable "private_subnet_1b_az" {
  default = "us-east-1b"
}

variable "ami_id" {
  default = "ami-002192a70217ac181"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "terraform-key"
}

variable "public_key_path" {
  default = "C:/Users/Dell/.ssh/id_ed25519.pub"
}