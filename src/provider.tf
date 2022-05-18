provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = var.AWS_REGION
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
