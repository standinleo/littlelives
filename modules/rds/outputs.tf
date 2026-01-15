output "endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.main.db_name
}

output "secret_arn" {
  description = "The ARN of the secret storing the database password"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}