terraform {
  required_version = "~> 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.13, < 5.45.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }

  }

  backend "s3" {
    encrypt = true # this is required when server-side encryption at rest is enabled on bucket
  }
}

provider "aws" {
  region = var.aws_region
}

provider "archive" {
}

provider "null" {
}
