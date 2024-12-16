resource "aws_instance" "nodes" {

  count = var.nodes_size

  ami           = local.nodes_ami_id
  instance_type = var.nodes_instance_type

  associate_public_ip_address = var.nodes_associate_public_ip_address
  monitoring                  = var.nodes_monitoring

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.loadtest.id]

  iam_instance_profile = aws_iam_instance_profile.loadtest.name
  user_data_base64     = local.setup_nodes_base64


  key_name = aws_key_pair.loadtest.key_name
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.ssh_user
    private_key = tls_private_key.loadtest.private_key_pem
  }


  # CONFIG FILESYSTEM AND PERMITIONS
  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.loadtest.private_key_pem}' > ~/.ssh/id_rsa",
      "chmod 600 ~/.ssh/id_rsa",
      "sudo mkdir -p ${var.loadtest_dir_destination} || true",
      "sudo chown ${var.ssh_user}:${var.ssh_user} ${var.loadtest_dir_destination} || true"
    ]
  }

  # PUBLISH ALL FILES
  provisioner "file" {
    destination = var.loadtest_dir_destination
    source      = var.loadtest_dir_source
  }

  # WAITING FOR NODES TO BE READY
  provisioner "remote-exec" {
    inline = [
      "echo 'START EXECUTION'",
      "while [ ! -f /tmp/finished-setup ]; do echo 'waiting setup to be instaled'; sleep 5; done",
      "sleep 10"
    ]
  }

  tags = merge(
    var.tags,
    var.nodes_tags,
    {
      "Name": "${var.name} Node ${count.index}"
    }
  )
}

locals {

  setup_nodes_executors = {
    jmeter = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/entrypoint.node.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
    bzt = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/entrypoint.node.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
    locust = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/locust.entrypoint.node.full.sh.tpl",
          {
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
    k6 = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/k6.entrypoint.node.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
            LOCUST_VERSION = var.locust_version
          }
        )
      )
    }
  }

  setup_nodes_executor = lookup(
    local.setup_nodes_executors,
    var.executor, {
      node_user_data_base64 = var.nodes_custom_setup_base64
    }
  )

  setup_nodes_base64 = local.setup_nodes_executor.node_user_data_base64

}
