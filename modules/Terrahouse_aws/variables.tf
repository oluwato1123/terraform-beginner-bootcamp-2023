variable "user_uuid" {
  description = "UUID for the user"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "User UUID must be in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}


variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters long and may only contain alphanumeric characters, hyphens, and periods."
  }
}


variable "index_html_filepath" {
  description = "Path to the index.html file"
  type        = string

  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The specified index.html file path is invalid or does not exist."
  }
}


variable "error_html_filepath" {
  description = "Path to the error.html file"
  type        = string

  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified error.html file path is invalid or does not exist."
  }
}

variable "content_version" {
  description = "The content version (positive integer starting at 1)"
  type        = number
  default     = 1

  validation {
    condition     = var.content_version > 0
    error_message = "Content version must be a positive integer"
  }
}

variable "assets_path" {
  description = "Path to assets folder"
  type = string
  
}