locals {
    auto_execute = var.auto_execute

    leader_private_ip = aws_instance.leader.private_ip

    executors = {
        jmeter = {
            waiting = "#while true; do source ~/.bashrc; echo 'waiting jmeter to be instaled'; sleep 10; jmeter --version; done"
            nodes_ips = join(",",aws_instance.nodes.*.private_ip) 
        }
        bzt = {
            waiting = "#"
            nodes_ips = "['${join("','",aws_instance.nodes.*.private_ip)}']"
        }
        locust = {
            waiting = "#"
            nodes_ips = join(",",aws_instance.nodes.*.private_ip)
            leader_ip = local.leader_private_ip
        }

        k6 = {
            waiting = "#"
            nodes_ips = ""
        }
    }
     
    executor = lookup(local.executors, var.executor, "")
    waiting_command = local.executor.waiting
    nodes_ips = local.executor.nodes_ips

}

resource "null_resource" "executor" {

    count = local.auto_execute ? 1 : 0

    depends_on = [
        aws_instance.leader,
        aws_instance.nodes
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
            "sleep 180",
            "source ~/.bashrc",
            "sleep 60",
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
    triggers = {
        always_run = timestamp()
    }

}
