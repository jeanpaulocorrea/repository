terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "jean-nsse-terraform-state-files"
    key            = "server/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nsse-terraform-state-locking"
  }

}

provider "aws" {
  region = var.region
  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }
}
