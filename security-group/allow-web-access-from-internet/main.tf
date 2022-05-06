terraform {
  backend "s3" {
    bucket = "mysawsbucket-states"
    key    = "aws_infra/security-group/allow-web-access-from-internet/states.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~>3.0"
  region  = "ap-southeast-1"
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "4.9.0"

  name                = "allow web access from internet"
  description         = "Security group for web-server with HTTP ports open within internet"
  vpc_id              = "vpc-0c2c638f3881d399d"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

