module "s3_bucket" {
  source = "git::https://github.com/Dheeraj2834/Terraform-daily-practice.git//Day-10-S3-Modules"

  bucket_name = "dheerajdheerajddddd"
  bucket_acl  = "private"

  bucket_tag = {
    Environment = "dev"
    Project     = "demo"
  }
}