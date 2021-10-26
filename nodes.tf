locals {
    split_enable = var.split_data_mass_between_nodes.enable
    split_data_mass_filename = var.split_data_mass_between_nodes.data_mass_filename
    split_size = var.nodes_size
    split_cmd =  local.split_enable ? "split -a 3 -d -nr/${local.split_size} ${local.split_data_mass_filename} ${local.split_data_mass_filename}" : ""
}


resource "aws_instance" "nodes" {
    
    count = var.nodes_size
    
    ami = var.nodes_ami_id
    instance_type = var.nodes_intance_type
  
    associate_public_ip_address = var.nodes_associate_public_ip_address
    monitoring = var.nodes_monitoring

    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.jmeter.id]
    
    iam_instance_profile = aws_iam_instance_profile.jmeter.name
     user_data_base64 = base64encode(
        templatefile(
            "${path.module}/scripts/entrypoint.node.full.sh.tpl",
            {}
        )
    )

    #PUBLISHING SCRIPTS AND DATA
    key_name = aws_key_pair.jmeter.key_name
    connection {
        host        = coalesce(self.public_ip, self.private_ip)
        type        = "ssh"
        user        = var.ssh_user
        private_key = tls_private_key.jmeter.private_key_pem
    }

    provisioner "remote-exec" {
        inline = ["mkdir -p /loadtest"]
    }

    provisioner "file" {
        destination = var.loadtest_dir_destination
        source      = var.loadtest_dir_source
    }

    tags = merge(
        var.tags,
        var.nodes_tags
    )
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
        private_key = tls_private_key.jmeter.private_key_pem
    }

    provisioner "remote-exec" {
        inline = ["mkdir -p /loadtest"]
    }

    provisioner "remote-exec" {
        inline = [
            #"while [ ! -f /var/lib/apache-jmeter-5.3/bin/jmeter ]; do sleep 10; done",
            "echo ${var.loadtest_dir_source}${format("%03d", count.index)}"
        ]
    }

    #provisioner "file" {
    #    source      = "${var.loadtest_dir_source}${format("%03d", count.index)}"
    #    destination = "${var.loadtest_dir_destination}/${var.loadtest_dir_source}"
    #}
}
