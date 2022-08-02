resource "aws_launch_template" "k3s_master" {
  name_prefix   = "k3s_master_tpl"
  image_id      = var.AMIS[var.AWS_REGION]
  instance_type = "t3.large"
  user_data     = data.template_cloudinit_config.k3s_master.rendered

  iam_instance_profile {
    name = var.instance_profile_name
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      encrypted   = true
    }
  }

  key_name = aws_key_pair.ssh_public_key.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.allow-strict.id]
  }

  metadata_options {
    http_tokens = "required"
  }
}

resource "aws_launch_template" "k3s_worker" {
  name_prefix   = "k3s_worker_tpl"
  image_id      = var.AMIS[var.AWS_REGION]
  instance_type = "t3.large"
  user_data     = data.template_cloudinit_config.k3s_worker.rendered

  iam_instance_profile {
    name = var.instance_profile_name
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      encrypted   = true
    }
  }

  key_name = aws_key_pair.ssh_public_key.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.allow-strict.id]
  }
  metadata_options {
    http_tokens = "required"
  }
}
