variable "bucket_name" {
  description = "The name of the S3 bucket to host the website."
  type        = string
  default     = "values-test-bucket-12345"

}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"

}

variable "tags" {

  description = "A map of tags to assign to resources."
  type        = map(string)
  default = {
    Project = "dev-env"
    Owner   = "CDN"
    Managed_by = "Terraform"
  }
}

variable "mime_types" {
  default = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".ico"  = "image/x-icon"
    ".txt"  = "text/plain"
    ".xml"  = "application/xml"
  }
}
