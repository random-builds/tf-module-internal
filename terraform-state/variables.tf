variable "s3_module_version" {
  type        = string
  description = "version of terraform module s3-bucket, https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest"
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.s3_module_version))
    error_message = "The s3_module_version value must be a full valid semantic version."
  }
}

variable "base_bucket_name" {
  type        = string
  description = "base name of the bucket, preferably includes account id or some unique identifier"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.base_bucket_name))
    error_message = "The base_bucket_name value must be lowercase alphanumeric characters or hyphens."
  }
}