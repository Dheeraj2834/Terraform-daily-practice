variable "lambda_bucket_name" {
  default = "dheerajdheeraj"
}

variable "lambda_role_name" {
  default = "demo-lambda-role"
}

variable "demo_lambda_name" {
  default = "demo-lambda"
}

variable "lambda_file_name" {
  default = "lambda-function.zip"
}

variable "lambda_runtime" {
  default = "python3.12"
}

variable "lambda_schedule_name" {
  default = "lambda_schedule_rule"
}

variable "schedule_expression" {
  default = "cron(0/5 * * * ? *)"
}