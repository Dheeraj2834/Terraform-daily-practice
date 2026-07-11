########################
# VPC
########################

resource "aws_vpc" "app_vpc" {

  cidr_block           = var.app_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.app_vpc_name
  }

}

########################
# Public Subnets
########################

resource "aws_subnet" "public_subnet_1a" {

  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = var.public_subnet_1a_az
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1A"
  }

}

resource "aws_subnet" "public_subnet_1b" {

  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.public_subnet_1b_cidr
  availability_zone       = var.public_subnet_1b_az
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1B"
  }

}

########################
# Private Subnets
########################

resource "aws_subnet" "private_subnet_1a" {

  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_1a_cidr
  availability_zone = var.private_subnet_1a_az

  tags = {
    Name = "Private-Subnet-1A"
  }

}

resource "aws_subnet" "private_subnet_1b" {

  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_1b_cidr
  availability_zone = var.private_subnet_1b_az

  tags = {
    Name = "Private-Subnet-1B"
  }

}

########################
# Internet Gateway
########################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "Terraform-IGW"
  }

}

########################
# Elastic IP
########################

resource "aws_eip" "nat_eip" {

  domain = "vpc"

}

########################
# NAT Gateway
########################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "Terraform-NAT"
  }

}

########################
# Public Route Table
########################

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.app_vpc.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "Public-RT"
  }

}

resource "aws_route_table_association" "public1" {

  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table_association" "public2" {

  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_rt.id

}

########################
# Private Route Table
########################

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.app_vpc.id

  route {

    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id

  }

  tags = {
    Name = "Private-RT"
  }

}

resource "aws_route_table_association" "private1" {

  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_rt.id

}

resource "aws_route_table_association" "private2" {

  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_rt.id

}

########################
# Security Group
########################

resource "aws_security_group" "app_sg" {

  name   = "terraform-sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

########################
# Key Pair
########################

resource "aws_key_pair" "terraform_key" {

  key_name   = var.key_name
  public_key = file(var.public_key_path)

}

########################
# Public EC2
########################

resource "aws_instance" "public_instance" {

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_1a.id
  key_name                    = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids       = [aws_security_group.app_sg.id]
  associate_public_ip_address  = true

  tags = {
    Name = "Public-EC2"
  }

}

########################
# Private EC2
########################

resource "aws_instance" "private_instance" {

  ami                   = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = aws_subnet.private_subnet_1a.id
  key_name              = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "Private-EC2"
  }

}