
terraform {
  backend "s3" {
    bucket       = "hanumantharao19-terraform-state-2026"
    key          = "ecr-project/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

