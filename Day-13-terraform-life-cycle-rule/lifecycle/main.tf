resource "aws_instance" "web" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"
  
  tags = {
    Name = "server"
  }

  lifecycle {
    ignore_changes = [
      tags, instance_type
    ]
  }
}