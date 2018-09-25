module "eu-west" {
  providers = {
    "aws" = "aws.eu-west"
  }

  source        = "modules/openvpn"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "eu-west-2"
  instance_type = "t2.micro"
  ami           = "${var.ami}"
  pub_key       = "${var.pub_key}"
}

output "eu-west-ip" {
  value = "${module.eu-west.ip}"
}

module "us-west" {
  providers = {
    "aws" = "aws.us-west"
  }

  source        = "modules/openvpn"
  instance_type = "t2.micro"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "us-west-2"
  ami           = "${var.ami}"
  pub_key       = "${var.pub_key}"
}

output "us-west-ip" {
  value = "${module.us-west.ip}"
}
