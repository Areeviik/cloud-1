terraform {
  required_version = ">=1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-42-cloud-1"
    key    = "001-network.tfstate"
    region = "us-west-2"
  }
}
