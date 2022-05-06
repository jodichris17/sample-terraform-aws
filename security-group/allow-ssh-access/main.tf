terraform {
  backend "s3" {
    bucket = "mysawsbucket-states"
    key    = "aws_infra/security-group/allow-ssh-access/states.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~>3.0"
  region  = "ap-southeast-1"
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 4.0"

  name                = "allow ssh access from all"
  description         = "allow ssh access from all"
  vpc_id              = "vpc-0c2c638f3881d399d"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}