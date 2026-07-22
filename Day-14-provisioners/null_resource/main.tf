provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("C:/Users/Dell/.ssh/id_ed25519.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"

  key_name = aws_key_pair.terraform_key.key_name

  tags = {
    Name = "pro"
  }
}

resource "null_resource" "configure_server" {

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Dell/.ssh/id_ed25519")
    host        = aws_instance.web.public_ip
  }

  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} >> inventory"
  }
}