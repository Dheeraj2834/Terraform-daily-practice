module "dev" {
  source = "../Day-13-source-modules"

vpc_cidr = var.vpc_cidr
vpc_name = var.vpc_name
public_subnet_1_cidr = var.public_subnet_1_cidr
az-1 = var.az-1
public_subnet_1_name = var.public_subnet_1_name
ami = var.ami
instance_type = var.instance_type
sg_name = var.sg_name
public_ec2_name = var.public_ec2_name
}