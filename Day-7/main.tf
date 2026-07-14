resource "aws_vpc" "D_VPC" {
  cidr_block = var.D_VPC_CIDR
  tags = {
    Name = var.D_VPC_Name
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.D_VPC.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az_1a
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.D_VPC.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az_1b
  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "D_VPC_IGW" {
  vpc_id = aws_vpc.D_VPC.id
  tags = {
    Name = var.D_VPC_IGW_Name
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.D_VPC.id
  route {
    cidr_block = var.public_route_table_cidr
    gateway_id = aws_internet_gateway.D_VPC_IGW.id
  }
  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "D_VPC_NAT_EIP" {
  domain = "vpc"

  tags = {
    Name = var.EIP_Name
  }
}

resource "aws_nat_gateway" "D_VPC_NAT" {
  allocation_id = aws_eip.D_VPC_NAT_EIP.id
  subnet_id     = aws_subnet.public_subnet.id
    tags = {
        Name = var.D_VPC_NAT_Name
    }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.D_VPC.id
  route {
    cidr_block     = var.private_route_table_cidr
    nat_gateway_id = aws_nat_gateway.D_VPC_NAT.id
  }
  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "vpc_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id = aws_vpc.D_VPC.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

resource "aws_instance" "Public_EC2" {
  ami           = var.AMI_instance
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.vpc_sg.id]

  tags = {
    Name = var.public_instance_name
  }
}

resource "aws_instance" "Private_EC2" {
  ami           = var.AMI_instance
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.vpc_sg.id]

  tags = {
    Name = var.private_instance_name
  }
}