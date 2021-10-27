locals {
    nodes_ips = (var.executor == "jmeter" ? 
        join(",",aws_instance.nodes.*.private_ip) : 
        "['${join("','",aws_instance.nodes.*.private_ip)}']")
}

resource "aws_instance" "leader" {
  
    ami = var.leader_ami_id
    instance_type = var.leader_instance_type

    associate_public_ip_address = var.leader_associate_public_ip_address
    monitoring = var.leader_monitoring
    
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.jmeter.id]
    
    iam_instance_profile = aws_iam_instance_profile.jmeter.name
    user_data_base64 = base64encode(
        templatefile(
            "${path.module}/scripts/entrypoint.leader.full.sh.tpl",
            {
                JVM_ARGS = var.leader_jvm_args,
            }
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
        inline = [
            "sudo mkdir -p /loadtest || true",
            "sudo chown ${var.ssh_user}:${var.ssh_user} /loadtest || true"
        ]
    }
    provisioner "file" {
        destination = var.loadtest_dir_destination
        source      = var.loadtest_dir_source
    }
    #EXECUTE SCRIPTS
    #provisioner "remote-exec" {
    #    inline = [
    #        #"while [ ! -f /var/lib/apache-jmeter-5.3/bin/jmeter ]; do sleep 10; done",
    #        replace(var.loadtest_entrypoint, "{NODES_IPS}", local.nodes_ips)
    #    ]
    #}

    tags = merge(
        var.tags,
        var.leader_tags,
        {
            "nodes" = join(",", aws_instance.nodes.*.private_ip)
        }
    )
}
