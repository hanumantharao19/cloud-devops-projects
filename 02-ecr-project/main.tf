
module "ecr" {
  source = "../modules/ecr"

  repository_name          = var.repository_name
  image_tag_mutability     = "MUTABLE"
  scan_on_push             = true
  encryption_type          = "AES256"
  enable_lifecycle_policy  = true
  max_image_count          = 10

  tags = {
    Project     = "Cloud-DevOps"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

