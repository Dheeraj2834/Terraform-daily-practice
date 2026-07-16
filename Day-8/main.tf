resource "aws_vpc" "D_VPC" {
  cidr_block = var.D_VPC_CIDR
  tags = {
    Name = var.D_VPC_Name
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.D_VPC.id
  cidr_block              = var.private_subnet_1_cidr
  availability_zone       = var.az_1a
  tags = {
    Name = var.private_subnet_1_name
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.D_VPC.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.az_1b
  tags = {
    Name = var.private_subnet_2_name
  }
}

resource "aws_internet_gateway" "D_VPC_IGW" {
  vpc_id = aws_vpc.D_VPC.id
  tags = {
    Name = var.public_route_table_name
  }
}

# resource "aws_eip" "D_VPC_NAT_EIP" {
#   domain = "vpc"

#   tags = {
#     Name = var.EIP_Name
#   }
# }

resource "aws_nat_gateway" "D_VPC_NAT" {
    vpc_id = aws_vpc.D_VPC.id
    tags = {
        Name = var.D_VPC_NAT_Name
    }
    availability_mode = var.availability_mode
    connectivity_type = "public"
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

resource "aws_route_table_association" "private_route_table_association-1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association-2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "sg" {
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

resource "aws_instance" "Frontend_EC2" {
  ami           = var.AMI_instance
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.public_instance_name
  }
}

resource "aws_instance" "Backend_EC2" {
  ami           = var.AMI_instance
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet_2.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.private_instance_name
  }
}

resource "aws_db_subnet_group" "rds" {
  name = "my-rds-subnet group"
  subnet_ids = [aws_subnet.private_subnet_1.id,aws_subnet.private_subnet_2.id]
}

resource "aws_db_instance" "main_db_inatance" {
    identifier = var.rds_identifier
    engine = var.rds_engine
    engine_version = var.rds_engine_version
    instance_class = var.rds_instance_class
    allocated_storage = var.rds_storage
    storage_type = var.rds_storage_type
    db_name = var.rds_db_name
    username = var.rds_username
    password = var.rds_password
    db_subnet_group_name = aws_db_subnet_group.rds.name
    vpc_security_group_ids = [aws_security_group.sg.id]
    publicly_accessible = false
    skip_final_snapshot = true
    backup_retention_period = 1
}

resource "aws_db_instance" "replica" {
  identifier = var.rds_identifier_replica
  engine = var.rds_engine
  instance_class = var.rds_instance_class
  replicate_source_db = aws_db_instance.main_db_inatance.arn
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot = true

   depends_on = [
    aws_db_instance.main_db_inatance
  ]
}

resource "aws_elasticache_subnet_group" "my_cache_subnet_group" {
  name       = var.cache_subnet_name
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_elasticache_cluster" "Redis-cache" {
  cluster_id         = var.cluster_id
  engine             = var.elasticache_engine
  node_type          = var.elasticache_node_type
  num_cache_nodes    = 1
  security_group_ids = [aws_security_group.sg.id]
  subnet_group_name  = aws_elasticache_subnet_group.my_cache_subnet_group.name
}