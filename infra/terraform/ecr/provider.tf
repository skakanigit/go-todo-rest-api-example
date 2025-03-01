terraform {
  required_version = ">= 1.5.7"

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = ">= 4.0.0"
        }
    }

    backend s3 {
        encrypt = true
        profile = "education"
    }
}

provider "aws" {
  region = "us-east-2"
  profile = var.aws_profile
}
