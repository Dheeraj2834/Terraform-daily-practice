resource "aws_vpc" "dev" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name   = var.vpc_name
    Region = var.region
  }
}

resource "aws_subnet" "public_subnet-1" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = var.public_subnet-1_cidr
  availability_zone = var.availability_zone-1a

  tags = {
    Name = var.public_subnet-1_name
  }
}

resource "aws_subnet" "public_subnet-2" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = var.public_subnet-2_cidr
  availability_zone = var.availability_zone-1b

  tags = {
    Name = var.public_subnet-2_name
  }
}

resource "aws_subnet" "private_subnet-1" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = var.private_subnet-1_cidr
  availability_zone = var.availability_zone-1a

  tags = {
    Name = var.private_subnet-1_name
  }
}

resource "aws_subnet" "private_subnet-2" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = var.private_subnet-2_cidr
  availability_zone = var.availability_zone-1b

  tags = {
    Name = var.private_subnet-2_name
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_name
  public_key = file(var.key_path)
}

resource "aws_security_group" "allow_all" {
  name        = var.sg_name
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    from_port   = var.sg_from_port
    to_port     = var.sg_to_port
    protocol    = var.sg_protocol
    cidr_blocks = var.sg_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet-1.id
  key_name                    = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "frontend_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet-1.id
  key_name                    = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = false

  tags = {
    Name = var.frontend_instance_name
  }
}