terraform {
  required_providers {
    aws = {
      version = ">= 4.34.0"
      source  = "hashicorp/aws"
    }
    kubernetes = {
      version = ">= 2.14.0"
      source  = "hashicorp/kubernetes"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = var.AWS_REGION
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
