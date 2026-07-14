# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.D_VPC.id
}

# Subnets
output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private_subnet.id
}

# Internet Gateway
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.D_VPC_IGW.id
}

# Elastic IP
output "nat_eip" {
  description = "Elastic IP allocated for NAT Gateway"
  value       = aws_eip.D_VPC_NAT_EIP.public_ip
}

# NAT Gateway
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.D_VPC_NAT.id
}

# Route Tables
output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.private_route_table.id
}

# Security Group
output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.vpc_sg.id
}

output "security_group_name" {
  description = "Security Group Name"
  value       = aws_security_group.vpc_sg.name
}

# EC2 Instances
output "public_instance_id" {
  description = "Public EC2 Instance ID"
  value       = aws_instance.Public_EC2.id
}

output "private_instance_id" {
  description = "Private EC2 Instance ID"
  value       = aws_instance.Private_EC2.id
}

output "public_instance_public_ip" {
  description = "Public IP of the Public EC2 Instance"
  value       = aws_instance.Public_EC2.public_ip
}

output "private_instance_private_ip" {
  description = "Private IP of the Private EC2 Instance"
  value       = aws_instance.Private_EC2.private_ip
}