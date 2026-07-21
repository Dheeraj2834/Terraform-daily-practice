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

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.az-2
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_2_name
  }
}

# Private Subnets

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.az-1

  tags = {
    Name = var.private_subnet_1_cidr
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.az-2

  tags = {
    Name = var.private_subnet_2_name
  }
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_name
  }
}

# Public Route Table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_rt_name
  }
}

# Public Route Table Associations

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway

resource "aws_nat_gateway" "nat" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = var.nat_name
    }
    availability_mode = "regional"
}

# Private Route Table

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.private_rt_name
  }
}

# Private Route Table Associations

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
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

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

# Frontend EC2 Instance

resource "aws_instance" "frontend_ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = file("C:/Terraform-practice/Terraform-daily-practice/Day-12-load-balancer/pass-values-to-VPC/userdata.sh")

  tags = {
    Name = var.frontend_ec2_name
  }
}

# Backend EC2 Instance

resource "aws_instance" "backend_ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = var.backend_ec2_name
  }
}

# frontend target group

resource "aws_lb_target_group" "tg" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.tg_name
  }
}

# frontend EC2 attachment to target group

resource "aws_lb_target_group_attachment" "frontend_ec2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.frontend_ec2.id
  port             = 80
}

# frontend application load balancer

resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_route53_zone" "dheetech" {
  name = var.domain_name
}

resource "aws_route53_record" "alb_dns" {
  zone_id = aws_route53_zone.dheetech.zone_id
  name    = "app.dheetech.xyz"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}