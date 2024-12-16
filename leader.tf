resource "aws_instance" "leader" {

  ami = local.leader_ami_id

  instance_type = var.leader_instance_type

  associate_public_ip_address = var.leader_associate_public_ip_address
  monitoring                  = var.leader_monitoring

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.loadtest.id]

  iam_instance_profile = aws_iam_instance_profile.loadtest.name
  user_data_base64     = local.setup_leader_base64

  #PUBLISHING SCRIPTS AND DATA
  key_name = aws_key_pair.loadtest.key_name
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.ssh_user
    private_key = tls_private_key.loadtest.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.loadtest.private_key_pem}' > ~/.ssh/id_rsa",
      "chmod 600 ~/.ssh/id_rsa",
      "sudo mkdir -p ${var.loadtest_dir_destination} || true",
      "sudo chown ${var.ssh_user}:${var.ssh_user} ${var.loadtest_dir_destination} || true"
    ]
  }
  #-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null

  provisioner "file" {
    destination = var.loadtest_dir_destination
    source      = var.loadtest_dir_source
  }

  tags = merge(
    var.tags,
    var.leader_tags,
    {
      "Name": "${var.name} Leader"
    }
  )
}


locals {
  setup_leader_executors = {
    jmeter = {
      leader_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/entrypoint.leader.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
    bzt = {
      leader_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/entrypoint.leader.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
    locust = {
      leader_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/locust.entrypoint.leader.full.sh.tpl",
          {
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
    k6 = {
      leader_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/k6.entrypoint.node.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args,
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
  }

  setup_leader_executor = lookup(local.setup_leader_executors, var.executor, {
    leader_user_data_base64 = var.leader_custom_setup_base64
  })

  setup_leader_base64 = local.setup_leader_executor.leader_user_data_base64
}
