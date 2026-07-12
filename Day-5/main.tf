resource "aws_s3_bucket" "demo" {
  bucket = "dheerajdheeraj"

  tags = {
    Name = "Terraform Demo"
  }
}