provider "aws" {
  alias                   = "eu-west"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  region                  = "eu-west-2"
}

provider "aws" {
  alias                   = "us-west"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  region                  = "us-west-2"
}
