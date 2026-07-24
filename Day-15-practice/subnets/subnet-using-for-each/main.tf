provider "aws" {
  region = "us-east-1"
}

# Get Availability Zones
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Local values for subnets
locals {
  public_subnets = {
    public-subnet-1 = {
      cidr = "10.0.1.0/24"
      az   = data.aws_availability_zones.available.names[0]
    }

    public-subnet-2 = {
      cidr = "10.0.2.0/24"
      az   = data.aws_availability_zones.available.names[1]
    }
    public-subnet-3 = {
      cidr = "10.0.3.0/24"
      az   = data.aws_availability_zones.available.names[2]
    }
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table"
  }
}

# Default Route
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate all public subnets with the route table
resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}