terraform {
  required_version = ">=1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }

  backend "s3" {
    bucket = "terraform-42-cloud-1"
    key    = "003-application.tfstate"
    region = "us-west-2"
  }
}
