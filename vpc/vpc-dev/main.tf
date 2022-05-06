terraform {
  backend "s3" {
    bucket = "mysawsbucket-states"
    key    = "aws_infra/vpc/vpc-dev/states.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~>3.0"
  region  = "ap-southeast-1"
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-dev"
  cidr = "10.0.0.0/18"

  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.0.0/24", "10.0.3.0/24"]

  enable_nat_gateway = true

  tags = {
    Environment = "development"
  }
}

