variable "AWS_REGION" {
  default     = "us-west-2"
  description = "AWS Zone"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-west-2 = "ami-0a22ed271d3dbf544"

    us-east-1 = "ami-0ae74ae9c43584639"
    eu-west-1 = "ami-0da36f7f059b7086e"
    us-west-1 = "ami-0f961012aa6154e3a"
  }
  description = "Ami image to use"
}

variable "PUBLIC_KEY" {
  default     = "~/.ssh/ctf.pub"
  description = "Public key for AWS"
}

variable "cluster_name" {
  type        = string
  default     = "k3s-cluster"
  description = "Cluster name"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-0151db5d01a7b37d1"
  description = "The vpc id"
}

variable "my_public_ip_cidr" {
  type        = string
  default     = "1.2.3.4/32"
  description = "My public ip CIDR"
}

variable "vpc_subnet_cidr" {
  type        = string
  default     = "172.31.0.0/16"
  description = "VPC subnet CIDR"
}

variable "vpc_subnets" {
  type        = list(any)
  default     = ["subnet-0621c8f7f75c9ad6d", "subnet-0f7e3c004c2aa90d3", "subnet-0f3149d253b5820ed", "subnet-09439ba287fcdecec"]
  description = "The vpc subnets ids"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  ## TODO: remove SSH
  default = [22, 80, 443, 6443, 31337]
}

variable "local_ingress_ports" {
  type        = list(number)
  description = "list of local ingress ports"
  default     = [22, 1025, 6443]
}

# tr -dc "[:alnum:]" < /dev/urandom | head -c52; echo
variable "k3s_token" {
  default     = "B6RmE8qHSDcLdIQGGNByF1D2ikZuVmsCUUWj2ZbH39FMO1L02v4O"
  type        = string
  description = "Override to set k3s cluster registration token"
}

variable "k3s_version" {
  default     = "v1.26.1+k3s1"
  type        = string
  description = "k3s version to deploy"
}

# resource "random_string" "lower" {
#   length  = 16
#   upper   = false
#   lower   = true
#   number  = false
#   special = false
# }
