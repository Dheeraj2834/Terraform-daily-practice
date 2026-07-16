# IAM Role for Lambda

resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Policy to Role

resource "aws_iam_role_policy_attachment" "lambda_admin" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Lambda Function

resource "aws_lambda_function" "demo_lambda" {
  function_name = var.demo_lambda_name

  filename = var.lambda_file_name
  source_code_hash = filebase64sha256("lambda-function.zip")

  role    = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = var.lambda_runtime

  timeout     = 300
  memory_size = 128
}

# CloudWatch Event Rule (EventBridge Schedule)

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = var.lambda_schedule_name
  schedule_expression = var.schedule_expression
}

# Connect EventBridge Rule to Lambda

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.lambda_schedule.name
  arn  = aws_lambda_function.demo_lambda.arn
}

# Allow EventBridge to Invoke Lambda

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"

  function_name = aws_lambda_function.demo_lambda.function_name

  principal  = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.lambda_schedule.arn
}