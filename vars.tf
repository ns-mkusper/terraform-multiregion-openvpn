# Top level variables.  Terraform inside modules may require
# these, but module instantiation typically will not override
# them if defaults are provided here.
variable "aws_profile" {
  description = "AWS profile to use"
  type        = "string"
}

variable "region" {
  description = "AWS default region"
  type        = "string"
  default     = "us-east-1"
}

variable "pub_key" {
  description = "SSH pub key"
  type        = "string"
}

variable "ami" {
  description = "Ubuntu AMI to use. Must match availability zone, instance type, etc"
  type        = "string"
  default     = ""
}

variable "dns_name" {
  description = "The DNS record to be used"
  type        = "string"
}
