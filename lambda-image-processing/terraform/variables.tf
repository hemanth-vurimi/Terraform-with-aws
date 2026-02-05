variable "region" {

  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"

}

variable "project_name" {
    description = "The name of the project."
    type        = string
    default     = "image-processing-app"
  
}

variable "environment" {
    description = "The deployment environment (e.g., dev, staging, prod)."
    type        = string
    default     = "dev"
  
}

variable "bucket_name" {
    description = "The base name for S3 buckets."
    type        = string
    default     = "img-proc-app"
  
}