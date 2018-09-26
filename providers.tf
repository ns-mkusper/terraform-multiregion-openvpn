provider "aws" {
  alias                   = "eu-west"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}

provider "aws" {
  alias                   = "us-west"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}

provider "aws" {
  alias                   = "us-east"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}

provider "aws" {
  alias                   = "ap-south"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}
