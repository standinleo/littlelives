variable "bucket_name" {
  description = "Name of the S3 bucket for uploads"
  type        = string
}

variable "deployment_bucket_name" {
  description = "Name of the S3 bucket for deployment artifacts"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}