provider "aws" {
  alias                   = "eu-west"
  region                  = "eu-west-2"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}

provider "aws" {
  alias                   = "us-west"
  region                  = "us-west-2"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}

provider "aws" {
  alias                   = "us-east"
  region                  = "us-east-1"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}

provider "aws" {
  alias                   = "ap-northeast"
  region                  = "ap-northeast-1"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${pathexpand("~/.aws/config")}"
  version                 = "~> 1.34"
}
