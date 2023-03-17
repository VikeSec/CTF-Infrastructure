module "ctfd" {
  count  = 1
  source = "./ctfd"

  DOMAIN_NAME         = var.DOMAIN_NAME
  CTFD_SUBDOMAIN_NAME = var.CTFD_SUBDOMAIN_NAME
}

# module "infra" {
#   count  = 1
#   source = "./infra"
# }

# module "o11y" {
#   count  = 1
#   source = "./o11y"
# }
