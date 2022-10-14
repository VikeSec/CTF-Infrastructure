data "template_cloudinit_config" "k3s_master" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", {})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/k3s-install-master.sh", {
      k3s_token   = var.k3s_token,
      k3s_version = var.k3s_version,
      k3s_url     = aws_lb.k3s-master-lb.dns_name,
      k3s_tls_san = aws_lb.k3s-master-lb.dns_name
    })
  }
}

data "template_cloudinit_config" "k3s_worker" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", {})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/k3s-install-worker.sh", {
      k3s_token   = var.k3s_token,
      k3s_version = var.k3s_version,
      k3s_url     = aws_lb.k3s-master-lb.dns_name,
      k3s_tls_san = aws_lb.k3s-master-lb.dns_name
    })
  }
}
