vpc_cidr_block     = "10.0.0.0/16"
vpc_name           = "my-vpc"
region             = "us-east-1"

public_subnet-1_cidr  = "10.0.1.0/24"
public_subnet-2_cidr  = "10.0.2.0/24"
private_subnet-1_cidr = "10.0.3.0/24"
private_subnet-2_cidr = "10.0.4.0/24"

availability_zone-1a = "us-east-1a"
availability_zone-1b = "us-east-1b"

public_subnet-1_name  = "public-subnet-us-east-1a"
public_subnet-2_name  = "public-subnet-us-east-1b"
private_subnet-1_name = "private-subnet-us-east-1a"
private_subnet-2_name = "private-subnet-us-east-1b"

key_name = "key-pair"
key_path = "C:/Users/Dell/.ssh/id_ed25519.pub"

sg_name        = "allow-all-sg"
sg_from_port   = 0
sg_to_port     = 0
sg_protocol    = "-1"
sg_cidr_blocks = ["0.0.0.0/0"]

instance_name = "MyInstance"
instance_type = "t3.micro"
frontend_instance_name = "Frontend_Instance"

ami_id = "ami-002192a70217ac181"