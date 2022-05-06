terraform {
  backend "s3" {
    bucket = "mysawsbucket-states"
    key    = "aws_infra/security-group/allow-mysql-access/states.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~>3.0"
  region  = "ap-southeast-1"
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws//modules/mysql"
  version = "~> 4.0"

  name                = "allow mysql access"
  description         = "Security group for allow mysql port"
  vpc_id              = "vpc-0c2c638f3881d399d"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}