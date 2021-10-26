locals {
    split_cmd =  "split -l$((`wc -l < onepiece.log`/5)) onepiece.log onepiece.split.log -da 4"
}


resource "aws_instance" "nodes" {
    
    count = var.nodes_total
    
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
  
    key_name = aws_key_pair.jmeter.key_name
    connection {
        host        = coalesce(self.public_ip, self.private_ip)
        type        = "ssh"
        user        = var.ssh_user
        private_key = tls_private_key.jmeter.private_key_pem
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
