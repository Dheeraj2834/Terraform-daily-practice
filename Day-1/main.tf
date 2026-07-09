resource "aws_vpc" "Dev" {
  cidr_block = var.vpc-dev
  tags = {
    Name = var.tag
  }
  region = var.region
}

resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.Dev.id
  cidr_block = var.subnet-public-1
  availability_zone = var.AZ-US-east-1a
  tags = {
    Name = var.tag-public-1
  }
}

resource "aws_subnet" "public-2" {
  vpc_id = aws_vpc.Dev.id
  cidr_block = var.subnet-public-2
  availability_zone = var.AZ-US-east-1b
  tags = {
    Name = var.tag-public-2
  }
}

resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.Dev.id
  cidr_block = var.subnet-private-1
  availability_zone = var.AZ-US-east-1a
  tags = {
    Name = var.tag-private-1
  }
}

resource "aws_subnet" "private-2" {
  vpc_id = aws_vpc.Dev.id
  cidr_block = var.subnet-private-2
  availability_zone = var.AZ-US-east-1b
  tags = {
    Name = var.tag-private-2
  }
}
