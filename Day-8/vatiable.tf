variable "D_VPC_CIDR" {
description = "CIDR block for the VPC"
}

variable "D_VPC_Name" {
  description = "Name of the VPC"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the public subnet"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the private subnet"
}

variable "az_1a" {
  description = "Availability zone for the subnets"
}

variable "az_1b" {
  description = "Availability zone for the subnets"
}

variable "private_subnet_1_name" {
  description = "Name of the public subnet"
}

variable "private_subnet_2_name" {
  description = "Name of the private subnet"
}

variable "D_VPC_NAT_Name" {
  description = "Name of the NAT Gateway"
}

variable "availability_mode" {
  description = "regional level NAT"
}

variable "private_route_table_cidr" {
  description = "CIDR block for the private route table"
}

# variable "EIP_Name" {
#   description = "Name of the Elastic IP"
# }

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

variable "rds_identifier" {
}

variable "rds_engine" {
}

variable "rds_engine_version" { 
}

variable "rds_instance_class" {
}

variable "rds_storage" {
}

variable "rds_storage_type"{
}

variable "rds_db_name" {
}

variable "rds_username" {
}

variable "rds_password" {
}

variable "rds_identifier_replica" {
}

variable "cache_subnet_name" {
}

variable "cluster_id" {
}

variable "elasticache_engine" {
}

variable "elasticache_node_type" {
}