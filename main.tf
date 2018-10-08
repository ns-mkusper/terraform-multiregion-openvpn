// Per AWS manpage: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/TutorialAddingLBRRegion.html
resource "aws_route53_zone" "dns" {
  name = "${var.dns_name}"
}

resource "aws_route53_record" "multi_region" {
  zone_id = "${aws_route53_zone.dns.zone_id}"
  name    = "multiregion.${aws_route53_zone.dns.name}"
  type    = "A"
  ttl     = "5"

  records = [
    "${module.eu-west.ip}",
    "${module.us-west.ip}",
    "${module.us-east.ip}",
    "${module.ap-northeast.ip}",
  ]
}

// Modules for Regions
module "eu-west" {
  providers = {
    "aws" = "aws.eu-west"
  }

  source        = "modules/openvpn"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "eu-west-2"
  instance_type = "t3.nano"
  ami           = "${var.ami}"
  pub_key       = "_keys/${var.pub_key}"
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
  pub_key       = "_keys/${var.pub_key}"
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
  pub_key       = "_keys/${var.pub_key}"
}

module "ap-northeast" {
  providers = {
    "aws" = "aws.ap-northeast"
  }

  source        = "modules/openvpn"
  instance_type = "t3.nano"
  aws_profile   = "${var.aws_profile}"
  aws_region    = "ap-northeast-1"
  ami           = "${var.ami}"
  pub_key       = "_keys/${var.pub_key}"
}
