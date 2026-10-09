
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "git::https://github.com/hanumantharao19/terraform-modules.git//vpc?ref=v1.0.0"

  vpc_name = "payment-dev"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = {
    public-1 = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    }

    public-2 = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
    }
  }

  private_subnets = {
    private-1 = {
      cidr    = "10.0.11.0/24"
      az      = "us-east-1a"
      nat_key = "public-1"
    }

    private-2 = {
      cidr    = "10.0.12.0/24"
      az      = "us-east-1b"
      nat_key = "public-2"
    }
  }

  enable_nat_gateway = true
  single_nat_gateway = false
}
