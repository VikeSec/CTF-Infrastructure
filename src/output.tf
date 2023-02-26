data "aws_instances" "masters" {
  instance_tags = {
    Name = "k3s-master"
  }
}

output "masters-public-ips" {
  value = data.aws_instances.masters.public_ips
}

data "aws_instances" "workers" {
  instance_tags = {
    Name = "k3s-worker"
  }
}

output "workers-publics-ips" {
  value = data.aws_instances.workers.public_ips
}
