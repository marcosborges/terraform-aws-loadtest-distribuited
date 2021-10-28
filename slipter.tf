locals {
    split_enable = var.split_data_mass_between_nodes.enable
    split_data_mass_filename = var.split_data_mass_between_nodes.data_mass_filename
    split_size = var.nodes_size
    split_cmd =  local.split_enable ? "split -a 3 -d -nr/${local.split_size} ${local.split_data_mass_filename} ${local.split_data_mass_filename}" : "echo 'auto split disabled'"
}

resource "null_resource" "split_data" {
    provisioner "local-exec" {
        command = local.split_cmd
    }
}


resource "null_resource" "publish_split_data" {

    count = local.split_enable ? var.nodes_size : 0

    depends_on = [
        null_resource.split_data,
        aws_instance.nodes
    ]  

    connection {
        host        = coalesce(aws_instance.nodes[count.index].public_ip, aws_instance.nodes[count.index].private_ip)
        type        = "ssh"
        user        = var.ssh_user
        private_key = tls_private_key.loadtest.private_key_pem
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p ${var.loadtest_dir_destination}|| true",
            "sudo chown ${var.ssh_user}:${var.ssh_user} ${var.loadtest_dir_destination} || true"
        ]
    }

    provisioner "remote-exec" {
        inline = [
            #"while [ ! -f /var/lib/apache-jmeter-5.3/bin/jmeter ]; do sleep 10; done",
            "echo ${var.loadtest_dir_destination} ${format("%03d", count.index)}"
        ]
    }

    #provisioner "file" {
    #    source      = "${var.loadtest_dir_source}${format("%03d", count.index)}"
    #    destination = "${var.loadtest_dir_destination}/${var.loadtest_dir_source}"
    #}
}
