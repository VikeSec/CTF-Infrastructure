terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.1.0"
    }
  }
}

data "cloudflare_zone" "vikesecca" {
  name = "vikesec.ca"
}

resource "cloudflare_record" "cname" {
  zone_id = data.cloudflare_zone.vikesecca.id
  name    = "staging-ctf"
  value   = aws_lb.k3s-public-lb.dns_name
  type    = "CNAME"
  proxied = true
}
