#!/bin/bash

apt-get update
apt-get install -y software-properties-common unzip
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

local_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
flannel_iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)')
provider_id=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)/$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

first_instance=$(aws ec2 describe-instances --filters Name=tag-value,Values=k3s-master Name=instance-state-name,Values=running --query 'sort_by(Reservations[].Instances[], &LaunchTime)[:-1].[InstanceId]' --output text | head -n1)
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

hostnamectl set-hostname "$instance_id"
hostname "$instance_id"

if [[ "$first_instance" == "$instance_id" ]]; then
  # shellcheck disable=SC2154 # These vars are templated by Terraform so they do exist
  until (curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${k3s_version}" K3S_TOKEN="${k3s_token}" sh -s - --cluster-init --node-ip "$local_ip" --advertise-address "$local_ip" --flannel-iface "$flannel_iface" --tls-san "${k3s_tls_san}" --kubelet-arg="provider-id=aws:///$provider_id"); do
    echo 'k3s did not install correctly'
    sleep 2
  done
else
  # shellcheck disable=SC2154 # These vars are templated by Terraform so they do exist
  until (curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${k3s_version}" K3S_TOKEN="${k3s_token}" sh -s - --server "https://${k3s_url}:6443" --node-ip "$local_ip" --advertise-address "$local_ip" --flannel-iface "$flannel_iface" --tls-san "${k3s_tls_san}" --kubelet-arg="provider-id=aws:///$provider_id"); do
    echo 'k3s did not install correctly'
    sleep 2
  done
fi

until kubectl get pods -A | grep 'Running'; do
  echo 'Waiting for k3s startup'
  sleep 5
done

kubectl taint nodes "$instance_id" node-role.kubernetes.io/master=:NoSchedule
# kubectl get nodes -o jsonpath="{range .items[*]}{.metadata.name} {.spec.taints[?(@.effect=='NoSchedule')].effect}{\"\n\"}{end}"
