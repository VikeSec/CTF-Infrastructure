module "infra" {
  count  = 1
  source = "./infra"
}

module "k8s" {
  count  = 1
  source = "./k8s"
}
