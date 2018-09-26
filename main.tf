module "eu-west" {
  providers = {
    "aws" = "aws.eu-west"
  }

  source        = "modules/openvpn"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "eu-west-2"
  instance_type = "t3.nano"
  ami           = "${var.ami}"
  pub_key       = "${var.pub_key}"
}

module "us-west" {
  providers = {
    "aws" = "aws.us-west"
  }

  source        = "modules/openvpn"
  instance_type = "t3.nano"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "us-west-2"
  ami           = "${var.ami}"
  pub_key       = "${var.pub_key}"
}

module "us-east" {
  providers = {
    "aws" = "aws.us-east"
  }

  source        = "modules/openvpn"
  instance_type = "t3.nano"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "us-east-1"
  ami           = "${var.ami}"
  pub_key       = "${var.pub_key}"
}

module "ap-south" {
  providers = {
    "aws" = "aws.ap-south"
  }

  source        = "modules/openvpn"
  instance_type = "t3.nano"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "ap-south-1"
  ami           = "${var.ami}"
  pub_key       = "${var.pub_key}"
}
