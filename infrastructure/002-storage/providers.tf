provider "aws" {
  region = var.aws.region

  default_tags {
    tags = merge(var.layer_metadata, { ManagedBy = "Terraform" })
  }
}
