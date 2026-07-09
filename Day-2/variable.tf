variable "vpc_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "public_subnet-1_cidr" {
  type = string
}

variable "public_subnet-2_cidr" {
  type = string
}

variable "private_subnet-1_cidr" {
  type = string
}

variable "private_subnet-2_cidr" {
  type = string
}


variable "availability_zone-1a" {
  type = string
}

variable "availability_zone-1b" {
  type = string
}

variable "public_subnet-1_name" {
  type = string
}

variable "public_subnet-2_name" {
  type = string
}

variable "private_subnet-1_name" {
  type = string
}

variable "private_subnet-2_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "key_path" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "sg_from_port" {
  type = number
}

variable "sg_to_port" {
  type = number
}

variable "sg_protocol" {
  type = string
}

variable "sg_cidr_blocks" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "frontend_instance_name" {
  type = string
}