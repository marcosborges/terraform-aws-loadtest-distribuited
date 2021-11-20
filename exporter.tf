locals {
  exporter_leader = var.elastic_exporter ? 1 : 0
  exporter_nodes  = var.elastic_exporter ? var.nodes_size : 0

  conf_logstash_file_content = ""

  conf_filebeat_file_content = ""

}

# Configure leader
resource "null_resource" "configure_exporter_on_leader" {

  count = local.exporter_leader

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

  #Filebeat
  provisioner "file" {
    content     = local.conf_logstash_file_content
    destination = "/etc/filebeat/filebeat.yml"
  }

  #Logstash
  provisioner "file" {
    content     = local.conf_filebeat_file_content
    destination = "/etc/logstash/conf.d/logstash.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl enable logstash",
      "sudo systemctl start logstash",
      "sudo systemctl enable filebeat",
      "sudo systemctl start filebeat"
    ]
  }

}

# Configure nodes
resource "null_resource" "configure_exporter_on_nodes" {

  count = local.exporter_nodes

  depends_on = [
    aws_instance.leader,
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
      "echo SETUP NODES ${count.index}",
      "sleep 1"
    ]
  }

}
