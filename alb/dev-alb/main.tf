terraform {
  backend "s3" {
    bucket = "mysawsbucket-states"
    key    = "aws_infra/alb/dev-alb/states.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~>3.0"
  region  = "ap-southeast-1"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id          = "vpc-0c2c638f3881d399d"
  subnets         = ["subnet-019a320ded3c8dfdb", "subnet-00e35f8b52ce9b808"]
  security_groups = ["sg-0a263738e152ec90d"]

  #   access_logs = {
  #     bucket = "mysawsbucket-states"
  #   }
}