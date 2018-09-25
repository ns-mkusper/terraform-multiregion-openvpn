# Top level variables.  Terraform inside modules may require
# these, but module instantiation typically will not override
# them if defaults are provided here.
variable "aws_profile" {
  type        = "string"
  description = "AWS profile to use"
}

variable "pub_key" {
  type        = "string"
  description = "SSH pub key"
}

variable "ami" {
  type        = "string"
  description = "Ubuntu AMI to use.  Must match availability zone, instance type, etc"
  default     = ""
}
