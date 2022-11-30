terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     = "eu-west-1"
}

terraform {
  backend "s3" {
  bucket     = "terraform-s3-bucket-wordpress"
  key        = "terraform.tfstate"
  region     = "eu-west-1"
  }
}