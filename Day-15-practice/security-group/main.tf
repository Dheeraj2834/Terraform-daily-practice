provider "aws" {
  region = "us-east-1"
}

# resource "aws_security_group" "web_sg" {
#   name = "web-security-group"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "web_sg" {
#   name        = "web-security-group"
#   description = "Security Group with multiple ports"

#   ingress = [
#     for port in [22, 80, 443, 8080, 9000, 3000, 8082, 8031] : {
#       description      = "Inbound rule for port ${port}"
#       from_port        = port
#       to_port          = port
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     }
#   ]

#    egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "web-security-group"
#   }
# }

# resource "aws_security_group" "web_sg" {
#   name        = "web-security-group"
#   description = "Allow SSH, HTTP, and HTTPS"

#   dynamic "ingress" {
#     for_each = var.ingress_ports

#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "Allow port ${ingress.value}"
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "web-security-group"
#   }
# }

resource "aws_security_group" "web_sg" {
  name   = "web-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      description = "Port ${ingress.key}"
      from_port   = tonumber(ingress.key)
      to_port     = tonumber(ingress.key)
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {Name = "D-SG"}
}