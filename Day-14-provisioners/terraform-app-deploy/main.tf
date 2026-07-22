provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "app_key" {
  key_name   = "app-key"
  public_key = file("C:/Users/Dell/.ssh/id_ed25519.pub")
}

resource "aws_instance" "app_server" {

  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"

  key_name = aws_key_pair.app_key.key_name

  tags = {
    Name = "Application-Server"
  }
}

resource "null_resource" "deploy_application" {

  depends_on = [
    aws_instance.app_server
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Dell/.ssh/id_ed25519")
    host        = aws_instance.app_server.public_ip
  }

  # Copy application deployment script
  provisioner "file" {

    source      = "app.sh"
    destination = "/tmp/app.sh"
  }

  # Execute deployment on EC2
  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/app.sh",
      "sudo /tmp/app.sh"
    ]
  }

  # Create deployment record locally
  provisioner "local-exec" {
    command = "echo Application deployed on ${aws_instance.app_server.public_ip} >> deploy.log"
  }
}