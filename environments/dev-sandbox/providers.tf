variable "aws_region" {
  type    = string
  default = "us-east-1"  # Change if you want to use a different region
}

provider "aws" {
  region = var.aws_region
}
