variable "bucket_name" {
    description = "The name of the S3 bucket"
    type        = string
    default     = "gloify-drift-bucket-2024"
  
}

variable "environment" {
    description = "The environment for the S3 bucket"
    type        = string
    default     = "dev"
  
}



