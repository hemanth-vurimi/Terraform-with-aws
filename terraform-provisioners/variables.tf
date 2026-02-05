variable "username" {
  description = "Username for SSH connection"
  type        = string
  default     = "ubuntu"
  
}

variable "key_pair" {
  description = "The name of the key pair to use for the instance"
  type        = string
  default     = "local-pro"  # Replace with your actual key pair name
  
}

variable "private_key_path" {
    description = "Path to the private key file for SSH connection"
    type        = string
    default     = "local-pro.pem"  # Replace with the actual path to your private key file
  
}