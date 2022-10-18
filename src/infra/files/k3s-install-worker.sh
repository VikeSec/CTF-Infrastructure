#!/bin/bash

apt-get update
apt-get install -y software-properties-common
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

local_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
flannel_iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)')
instance_id="$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
provider_id="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)/$instance_id"

hostnamectl set-hostname $instance_id
hostname $instance_id

until (curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${k3s_version}" K3S_TOKEN=${k3s_token} K3S_URL=https://${k3s_url}:6443 sh -s - --node-ip $local_ip --flannel-iface $flannel_iface --kubelet-arg="provider-id=aws:///$provider_id"); do
  echo 'k3s did not install correctly'
  sleep 5
done
