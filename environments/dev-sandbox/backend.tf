terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend block tells Terraform we want to use remote S3 state.
  # deploy.yml will pass the bucket/key/region values.
  backend "s3" {}
}
