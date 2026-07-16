output "lambda_function_name" {
  value       = aws_lambda_function.demo_lambda.function_name
}

output "lambda_function_arn" {
  value       = aws_lambda_function.demo_lambda.arn
}

output "lambda_role_name" {
  value       = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
}

output "eventbridge_rule_name" {
  value       = aws_cloudwatch_event_rule.lambda_schedule.name
}

output "eventbridge_rule_arn" {
  value       = aws_cloudwatch_event_rule.lambda_schedule.arn
}

output "eventbridge_schedule_expression" {
  value       = aws_cloudwatch_event_rule.lambda_schedule.schedule_expression
}