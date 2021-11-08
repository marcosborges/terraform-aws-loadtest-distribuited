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

    entrypoint = replace(
        replace(
            var.loadtest_entrypoint, 
            "{NODES_IPS}", 
            local.nodes_ips
        ),
        "{LEADER_IP}", 
        local.leader_private_ip
    )

}

resource "null_resource" "executor" {

    count = local.auto_execute ? 1 : 0

    depends_on = [
        null_resource.spliter_execute_command,
        aws_instance.nodes,
        aws_instance.leader
    ]  

    connection {
        host        = coalesce(aws_instance.leader.public_ip, aws_instance.leader.private_ip)
        type        = "ssh"
        user        = var.ssh_user
        private_key = tls_private_key.loadtest.private_key_pem
    }

    #WAITING FOR INSTANCE FINISHING SETUP
    provisioner "remote-exec" {
        inline = [
            "echo 'START EXECUTION'",
            local.waiting_command,
        ]
    }

    #CLEANING UP
    provisioner "remote-exec" {
        inline = [
            "sudo chmod 777 /var/www/html -Rf",
            "sudo rm -rf /var/www/html/*",
            "sudo rm -rf /loadtest/logs",
        ]
    }

    #EXECUTING LOAD TEST
    provisioner "remote-exec" {
        inline = [
            "echo DIR: ${var.loadtest_dir_destination}",
            "ls -lah ${var.loadtest_dir_destination}",
            "cd ${var.loadtest_dir_destination}",
            "echo ${local.entrypoint}",
            local.entrypoint
        ]
    }

    triggers = {
        always_run = timestamp()
    }

}
