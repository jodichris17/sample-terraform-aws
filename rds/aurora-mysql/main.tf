terraform {
  backend "s3" {
    bucket = "mysawsbucket-states"
    key    = "aws_infra/rds/aurora/states.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~>4.0"
  region  = "ap-southeast-1"
}

module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name           = "test-aurora-db-mysql"
  engine         = "aurora-mysql"
  engine_version = "5.7"
  instance_class = "db.t2.small"
  instances = {
    one = {}
    2 = {
      instance_class = "db.t2.small"
    }
  }

  vpc_id  = "vpc-0c2c638f3881d399d"
  subnets = ["subnet-019a320ded3c8dfdb", "subnet-00e35f8b52ce9b808"]

  allowed_security_groups = ["sg-0ddc027c2f4ff4fd8"]
  allowed_cidr_blocks     = ["0.0.0.0/0"]

  publicly_accessible = true
  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = "aurora-mysql"
  db_cluster_parameter_group_name = "aurora-mysql"

  enabled_cloudwatch_logs_exports = ["error"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}