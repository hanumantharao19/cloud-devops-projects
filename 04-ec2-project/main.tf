
provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "git::https://github.com/hanumantharao19/terraform-modules.git//ec2?ref=v1.0.0"

  name          = "sonarqube-server"
  ami_id        = var.ami_id
  instance_type = "t2.small"
  subnet_id     = var.subnet_id

  vpc_security_group_ids = var.security_group_ids

  root_volume_size = 30
  root_volume_type = "gp3"

  iam_instance_profile = var.iam_instance_profile

  tags = {
    Environment = "dev"
    Application = "sonarqube"
    ManagedBy   = "Terraform"
  }
}

}
