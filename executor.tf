locals {
    auto_execute = var.auto_execute

    leader_private_ip = aws_instance.leader.private_ip

    executors = {
        jmeter = {
            nodes_ips = join(",",aws_instance.nodes.*.private_ip) 
        }
        bzt = {
            nodes_ips = "['${join("','",aws_instance.nodes.*.private_ip)}']"
        }
        locust = {
            nodes_ips = join(",",aws_instance.nodes.*.private_ip)
            leader_ip = local.leader_private_ip
        }
        k6 = {
            waiting = "#"
            nodes_ips = ""
        }
    }
     
    executor = lookup(local.executors, var.executor, "")
    waiting_command = "while [ ! -f /tmp/finished-setup ]; do echo 'waiting setup to be instaled'; sleep 5; done"
    nodes_ips = local.executor.nodes_ips

}

resource "null_resource" "executor" {

    count = local.auto_execute ? 1 : 0

    depends_on = [
        null_resource.publish_split_data,
        aws_instance.nodes,
        aws_instance.leader
    ]  

    connection {
        host        = coalesce(aws_instance.leader.public_ip, aws_instance.leader.private_ip)
        type        = "ssh"
        user        = var.ssh_user
        private_key = tls_private_key.loadtest.private_key_pem
    }

    #EXECUTE SCRIPTS
    provisioner "remote-exec" {
        inline = [
            "echo 'START EXECUTION'",
            local.waiting_command,
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "echo DIR: ${var.loadtest_dir_destination}",
            "cd ${var.loadtest_dir_destination}",
            "echo PATH: $PATH",
            "echo JVM_ARGS: $JVM_ARGS",
            "sudo chmod 777 /var/www/html -Rf",
            "sudo rm -rf /var/www/html/*",
            "sudo rm -rf /loadtest/logs",
            "echo ${replace(var.loadtest_entrypoint, "{NODES_IPS}", local.nodes_ips)}",
            replace(var.loadtest_entrypoint, "{NODES_IPS}", local.nodes_ips)
        ]
    }

    # triggers = {
    #     always_run = timestamp()
    # }

}
