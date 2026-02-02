output "bucket_name" {
    description = "The name of the S3 bucket"
    value       = aws_s3_bucket.drift_bucket.bucket
}

output "bucket_arn" {
    description = "The ARN of the S3 bucket"
    value       = aws_s3_bucket.drift_bucket.arn
  
}

output "name_instance_id" {
    description = "The ID of the demo server instance"
    value       = aws_instance.demo-server.id
  
}