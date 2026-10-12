provider "aws" {
  region = "us-east-1"
}


# ============================================================
# VPC
# ============================================================

module "vpc" {
  source = "git::https://github.com/hanumantharao19/terraform-modules.git//vpc?ref=v1.0.0"

  vpc_name = "product-dev-vpc"

  vpc_cidr = "10.10.0.0/16"

  public_subnets = {
    public-1 = {
      cidr = "10.10.1.0/24"
      az   = "us-east-1a"
    }

    public-2 = {
      cidr = "10.10.2.0/24"
      az   = "us-east-1b"
    }
  }

  private_subnets = {
    private-1 = {
      cidr = "10.10.11.0/24"
      az   = "us-east-1a"
    }

    private-2 = {
      cidr = "10.10.12.0/24"
      az   = "us-east-1b"
    }
  }

  enable_nat_gateway = true
  single_nat_gateway = true
}


# ============================================================
# IAM
# ============================================================

module "iam" {
  source = "git::https://github.com/hanumantharao19/terraform-modules.git//iam/iam-eks?ref=v1.0.0"

  name_prefix = "product-dev"

  environment = "dev"
}


# ============================================================
# EKS
# ============================================================

module "eks" {
  source = "git::https://github.com/hanumantharao19/terraform-modules.git//eks?ref=v1.0.0"

  cluster_name = "product-dev-eks"

  environment = "dev"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn

  node_role_arn = module.iam.eks_node_role_arn

  kubernetes_version = "1.35"

  instance_types = [
    "t3.medium"
  ]

  desired_size = 2
  min_size     = 1
  max_size     = 3

  endpoint_public_access = true

   public_access_cidrs = [
    "0.0.0.0/0"
  ]
}

