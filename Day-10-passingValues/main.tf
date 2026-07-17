module "s3_bucket" {
  source = "../Day-10-S3-Modules"

  bucket_name = "dheerajdheerajd"
  bucket_acl  = "private"

  bucket_tag = {
    Environment = "dev"
    Project     = "demo"
  }
}