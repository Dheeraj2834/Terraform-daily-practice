resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("C:/Users/Dell/.ssh/id_ed25519.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"

  key_name = aws_key_pair.terraform_key.key_name

  tags = {
    Name = "provi"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Dell/.ssh/id_ed25519")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "hello.txt"
    destination = "/tmp/hello.txt"
  }

}