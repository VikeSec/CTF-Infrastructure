module "infra" {
  count  = 1
  source = "./infra"

  AWS_REGION          = var.AWS_REGION
  DOMAIN_NAME         = var.DOMAIN_NAME
  CTFD_SUBDOMAIN_NAME = var.CTFD_SUBDOMAIN_NAME
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = <<EOT
ssh -o StrictHostKeyChecking=no ubuntu@${data.aws_instances.masters.public_ips[0]} sudo chmod 666 /etc/rancher/k3s/k3s.yaml

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${data.aws_instances.masters.public_ips[0]}:/etc/rancher/k3s/k3s.yaml ~/.kube/config

ssh -o StrictHostKeyChecking=no ubuntu@${data.aws_instances.masters.public_ips[0]} sudo chmod 600 /etc/rancher/k3s/k3s.yaml

EOT
  }
}

module "k8s" {
  count  = 1
  source = "./k8s"

  DOMAIN_NAME         = var.DOMAIN_NAME
  CTFD_SUBDOMAIN_NAME = var.CTFD_SUBDOMAIN_NAME
}

module "challs" {
  count  = 1
  source = "./challs"
}
