provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4"
    }
  }
} 