variable "region" {
  description = "The AWS region to deploy in"
  type        = string
}

variable "source_file_path" {
  description = "Path to the CSV file to upload"
  type        = string
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
  default     = "projeto"
}
