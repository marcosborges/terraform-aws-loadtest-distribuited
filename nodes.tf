resource "aws_instance" "nodes" {
    
    count = var.nodes_size
    
    ami = local.nodes_ami_id
    instance_type = var.nodes_intance_type
  
    associate_public_ip_address = var.nodes_associate_public_ip_address
    monitoring = var.nodes_monitoring

    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.loadtest.id]
    
    iam_instance_profile = aws_iam_instance_profile.loadtest.name
    user_data_base64 = local.nodes_user_data_base64

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
            "sudo mkdir -p ${var.loadtest_dir_destination} || true",
            "sudo chown ${var.ssh_user}:${var.ssh_user} ${var.loadtest_dir_destination} || true"
        ]
    }

    provisioner "file" {
        destination = var.loadtest_dir_destination
        source      = var.loadtest_dir_source
    }

    provisioner "remote-exec" {
        inline = [
            "echo 'START EXECUTION'",
            "while [ ! -f /tmp/finished-setup ]; do echo 'waiting setup to be instaled'; sleep 5; done",
            "sleep 10"
        ]
    }

    tags = merge(
        var.tags,
        var.nodes_tags
    )
}
