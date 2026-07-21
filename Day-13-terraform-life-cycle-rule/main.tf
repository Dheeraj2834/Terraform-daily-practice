# VPC

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Dev-VPC"
  }
}

# Public Subnets

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_instance" "public_ec2" {
  ami                         = "ami-01edba92f9036f76e"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = true

  tags = {
    Name = "public-instance"
  }
}

resource "aws_s3_bucket" "name" {
bucket = "dheerajdheeraj"
}