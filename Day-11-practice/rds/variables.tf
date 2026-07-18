variable "vpc_cidr" {
  default = ""
}

variable "vpc_name" {
  default = ""
}

variable "az_1" {
  default = ""
}

variable "az_2" {
  default = ""
}

variable "public_subnet_1_cidr" {
  default = ""
}

variable "public_subnet_2_cidr" {
  default = ""
}

variable "public_subnet_1_name" {
  default = ""
}

variable "public_subnet_2_name" {
  default = ""
}

variable "sg_name" {
  default = ""
}

variable "db_identifier" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "engine_version" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "db_subnet_group" {}
variable "db_subnet_group_name" {}
variable "rds_name" {}