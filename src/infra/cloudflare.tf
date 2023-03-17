terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.1.0"
    }
  }
}

data "cloudflare_zone" "vikesecca" {
  name = var.DOMAIN_NAME
}

resource "cloudflare_record" "cname" {
  zone_id = data.cloudflare_zone.vikesecca.id
  name    = var.CTFD_SUBDOMAIN_NAME
  value   = aws_lb.k3s-public-lb.dns_name
  type    = "CNAME"
  proxied = true
}
