output "lambda_function_name" {
  value = aws_lambda_function.demo_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.demo_lambda.arn
}

output "lambda_s3_bucket" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_zip_location" {
  value = aws_s3_object.lambda_zip.key
}