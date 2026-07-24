provider "aws" {
  region = "ap-south-2"
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("C:/Users/Dell/.ssh/id_ed25519.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-0b2ac1bf38835e348"
  instance_type = "t3.small"
  tags = {
    Name = "Dev"
  }
  key_name = aws_key_pair.terraform_key.key_name
}

resource "null_resource" "configure" {
  triggers = {
    instance_id = aws_instance.web.id
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx",
      "systemctl start nginx",
      "systemctl enable nginx",
      "sudo yum install git -y",
      "sudo yum install python3-pip -y",
      "sudo yum install mariadb105-server -y"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/Dell/.ssh/id_ed25519")
      host        = aws_instance.web.public_ip
    }
  }
}