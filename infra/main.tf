terraform {
  required_version = "~> 1.4.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-demo-yamashita"
    key    = "iam-demo.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  default_tags {
    tags = {
      project = local.project_name
    }
  }
}

locals {
  project_name = "iam-demo"
}
