provider "aws" {
  region = "us-east-1"
}

module "sonar-vpc" {
  source = "git::https://github.com/hanumantharao19/terraform-modules.git//vpc?ref=v1.0.2"

  vpc_name = "sonar-dev"
  vpc_cidr = "20.0.0.0/16"

  public_subnets = {
    public-1 = {
      cidr = "20.0.1.0/24"
      az   = "us-east-1a"
    }
  }
  enable_nat_gateway = false
}


