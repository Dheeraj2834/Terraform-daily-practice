# VPC

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.az-1
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_1_name
  }
}

# Security Group

resource "aws_security_group" "web_sg" {
  name   = var.sg_name
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

# Public EC2 Instance

resource "aws_instance" "public_ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.public_ec2_name
  }
}

#New Instance

resource "aws_instance" "new_instance" {
  ami           = "ami-0b826bb6d96d2afe4"
  instance_type = "t3.micro"
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = {
    Name = "second-instance"
  }
}

# s3 bucket imported

resource "aws_s3_bucket" "my_bucket" {
  bucket = "dheerajdheeraj"
}

# created new subnet via console and crerating new instance using thst subnet

data "aws_subnet" "manual" {
  filter {
    name = "tag:Name"
    values = ["subnet-2"]
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_instance" "manual_instance" {
  ami           = "ami-0b826bb6d96d2afe4"
  instance_type = "t3.micro"
  subnet_id                   = data.aws_subnet.manual.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = {
    Name = "third-instance"
  }
}

# utilising existing S3 bucket and enabled the versioning

data "aws_s3_bucket" "manual_s3" {
  bucket = "dheerajbandarudheeraj"
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = data.aws_s3_bucket.manual_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
