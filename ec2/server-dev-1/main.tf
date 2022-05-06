terraform {
  backend "s3" {
    bucket = "mysawsbucket-states"
    key    = "aws_infra/ec2/server-dev-1/states.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~>3.0"
  region  = "ap-southeast-1"
}

data "aws_vpc" "vpc" {
  state = "available"

  filter {
    name   = "tag:Name"
    values = ["vpc-dev"]
  }
}

data "aws_subnet" "subnet" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["vpc-dev-private-ap-southeast-1a"]
  }
}

data "aws_security_groups" "sg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = "server-dev-1"
  count                  = 1
  ami                    = "ami-0750a20e9959e44ff"
  instance_type          = "t2.micro"
  key_name               = "dev"
  monitoring             = true
  vpc_security_group_ids = ["sg-0cd52a8470d832bf5"]
  subnet_id              = data.aws_subnet.subnet.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
