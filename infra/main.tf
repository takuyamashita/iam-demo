
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

provider "aws" {}

variable "project" {
  type = string
}
