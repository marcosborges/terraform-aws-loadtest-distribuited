locals {
    spliter_enable = var.split_data_mass_between_nodes.enable
    split_size = var.nodes_size
    split_data_mass_filenames = local.spliter_enable ? var.split_data_mass_between_nodes.data_mass_filenames : []

    # SPLIT COMMAND TEMPLATE
    split_cmd_tpl = "split -a 3 -d -nr/${local.split_size} ${var.loadtest_dir_destination}/{FILENAME} ${var.loadtest_dir_destination}/{FILENAME}"
    # RENDERIZATION COMMAND TEMPLATE
    leader_split_cmds = [for file in local.split_data_mass_filenames : replace(local.split_cmd_tpl, "{FILENAME}", file)]
    # SKIP SSH/SCP HOST VERIFICATION
    ssh_skip_hosts_verification = " -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "

    # TRANSFER SCP COMMAND TEMPLATE
    scp_cmd_tpl = "scp ${local.ssh_skip_hosts_verification} ${var.loadtest_dir_destination}/{FILE_IN} ${var.ssh_user}@{HOST}:${var.loadtest_dir_destination}/{FILE_OUT}"
    # RENDERIZATION CLEANUP SCP COMMAND
    leader_scp_cmds = flatten([
        for file in local.split_data_mass_filenames : [
            for index, host in aws_instance.nodes : [
                replace(
                    replace(
                        replace(
                            local.scp_cmd_tpl, 
                            "{FILE_IN}", 
                            "${file}${format("%03d", index)}"
                        ), 
                        "{FILE_OUT}",  
                        file
                    ),
                    "{HOST}",  
                    host.private_ip
                )
            ]
        ]
    ])

    # CLEANUP SSH COMMAND TEMPLATE OF INTO NODES BY LEADER
    leader_ssh_nodes_cleanup_cmd_tpl = "ssh ${local.ssh_skip_hosts_verification} ${var.ssh_user}@{HOST} -c \"rm -rf ${var.loadtest_dir_destination}/{FILE}\" || true"
    # RENDERIZATION CLEANUP SSH COMMAND
    leader_ssh_nodes_cleanup_cmds = flatten([
        for file in local.split_data_mass_filenames : [
            for host in aws_instance.nodes : [
                replace(
                    replace(
                        local.leader_ssh_nodes_cleanup_cmd_tpl, 
                        "{FILE}", 
                        file
                    ), 
                    "{HOST}",  
                    host.private_ip
                )
            ]
        ]
    ])

    # JOIN COMMANDS TO BE EXECUTED BY LEADER
    leader_cmds = concat(
        ["echo AUTO SPLITER"],
        local.leader_split_cmds, 
        local.leader_ssh_nodes_cleanup_cmds,
        local.leader_scp_cmds
    )
}

resource "null_resource" "spliter_execute_command" {
    
    # CONNECT TO LEADER
    connection {
        host        = coalesce(aws_instance.leader.public_ip, aws_instance.leader.private_ip)
        type        = "ssh"
        user        = var.ssh_user
        private_key = tls_private_key.loadtest.private_key_pem
    }

    # EXECUTION OF ALL COMMANDS DEFINED INTO local.leader_cmds
    provisioner "remote-exec" {
        inline = local.leader_cmds
    }
    
}
