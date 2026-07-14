variable "D_VPC_CIDR" {
description = "CIDR block for the VPC"
}

variable "D_VPC_Name" {
  description = "Name of the VPC"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
}

variable "az_1a" {
  description = "Availability zone for the subnets"
}

variable "az_1b" {
  description = "Availability zone for the subnets"
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
}

variable "D_VPC_IGW_Name" {
  description = "Name of the Internet Gateway"
}

variable "D_VPC_NAT_Name" {
  description = "Name of the NAT Gateway"
}

variable "public_route_table_cidr" {
  description = "CIDR block for the public route table"
}

variable "private_route_table_cidr" {
  description = "CIDR block for the private route table"
}

variable "EIP_Name" {
  description = "Name of the Elastic IP"
}

variable "public_route_table_name" {
  description = "Name of the public route table"
}

variable "private_route_table_name" {
  description = "Name of the private route table"
}

variable "sg_name" {
  description = "Security Group Name"
  type        = string
}

variable "sg_description" {
  description = "Security Group Description"
  type        = string
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to access the security group"
  type        = list(string)
}

variable "AMI_instance" {
    description = "AMI for instance creation"
}

variable "instance_type" {
    description = "instance type"
}

variable "public_instance_name" {
  description = "this is public instance name"
}

variable "private_instance_name" {
  description = "this is private instance name"
}