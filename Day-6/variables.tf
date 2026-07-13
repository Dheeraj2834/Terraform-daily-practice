variable "instance_type" {
  description = "Type of instance to be created"
  default     = "t3.micro"
}

variable "ami" {
  description = "AMI ID for the instance"
  default     = "ami-002192a70217ac181"
}

variable "instance_name" {
  description = "Name of the instance"
  default     = "TerraformExample"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "PublicSubnet"
}
