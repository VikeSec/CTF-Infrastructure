terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
}

provider "cloudflare" {
  api_token = yamldecode(file("~/.config/tokens/cloudflare.yml"))["api-token"]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
