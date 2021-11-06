locals {
    split_enable = var.split_data_mass_between_nodes.enable
    split_data_mass_filename = var.split_data_mass_between_nodes.data_mass_filenames[0]
    split_size = var.nodes_size
    split_cmd =  local.split_enable ? "cd ${var.loadtest_dir_source} && split -a 3 -d -nr/${local.split_size} ${local.split_data_mass_filename} ${local.split_data_mass_filename}" : "echo 'auto split disabled'"

    publish_split_data_count = local.split_enable ? var.nodes_size : 0

    # publish_files = flatten([
    #     for network_key, network in var.networks : [
    #     for subnet_key, subnet in network.subnets : {
    #         network_key = network_key
    #         subnet_key  = subnet_key
    #         network_id  = aws_vpc.example[network_key].id
    #         cidr_block  = subnet.cidr_block
    #     }
    #     ]
    # ])
}

resource "null_resource" "split_data" {
    
    provisioner "local-exec" {

        command = local.split_cmd
    }
}

resource "null_resource" "publish_split_data" {

    count = local.publish_split_data_count

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
            "rm ${var.loadtest_dir_destination}/${var.split_data_mass_between_nodes.data_mass_filenames[0]}",
            "echo XXXXXX ${var.loadtest_dir_destination}/${var.split_data_mass_between_nodes.data_mass_filenames[0]}${format("%03d", count.index)}",
            "mv ${var.loadtest_dir_destination}/${var.split_data_mass_between_nodes.data_mass_filenames[0]}${format("%03d", count.index)} ${var.loadtest_dir_destination}/${var.split_data_mass_between_nodes.data_mass_filenames[0]}"
        ]
    }

    #provisioner "file" {
    #    source      = "${var.loadtest_dir_source}${format("%03d", count.index)}"
    #    destination = "${var.loadtest_dir_destination}/${var.loadtest_dir_source}"
    #}
}
