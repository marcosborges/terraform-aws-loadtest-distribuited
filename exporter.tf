locals {
  default_exporters = {
    jmeter = {
      conf_logstash_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.logstash.conf.tpl", {}
      )
      conf_filebeat_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.filebeat.inputs.yml.tpl", {}
      )
      startup_leader_commands = [
        "echo \"ELASTIC_HOSTNAME=${var.elastic_exporter.elastic_hostname}\" >> /etc/environment",
        "echo \"ELASTIC_USERNAME=${var.elastic_exporter.elastic_username}\" >> /etc/environment",
        "echo \"ELASTIC_PASSWORD=${var.elastic_exporter.elastic_password}\" >> /etc/environment",
        "echo \"ELASTIC_INDEX=${var.elastic_exporter.elastic_index}\" >> /etc/environment",
        "source ~/.bashrc",
        "sudo systemctl enable logstash && sudo systemctl start logstash",
        "sudo systemctl enable filebeat && sudo systemctl start filebeat",
      ]
      startup_nodes_commands = [
        "echo \"ELASTIC_HOSTNAME=${var.elastic_exporter.elastic_hostname}\" >> /etc/environment",
        "echo \"ELASTIC_USERNAME=${var.elastic_exporter.elastic_username}\" >> /etc/environment",
        "echo \"ELASTIC_PASSWORD=${var.elastic_exporter.elastic_password}\" >> /etc/environment",
        "echo \"ELASTIC_INDEX=${var.elastic_exporter.elastic_index}\" >> /etc/environment",
        "source ~/.bashrc",
      ]
    }
    bzt = {
      conf_logstash_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.logstash.conf.tpl", {}
      )
      conf_filebeat_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.filebeat.inputs.yml.tpl", {}
      )
      startup_leader_commands = [
        "sudo systemctl enable logstash && sudo systemctl start logstash",
        "sudo systemctl enable filebeat && sudo systemctl start filebeat",
      ]
      startup_nodes_commands = []
    }
    locust = {
      conf_logstash_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.logstash.conf.tpl", {}
      )
      conf_filebeat_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.filebeat.inputs.yml.tpl", {}
      )
      startup_leader_commands = [
        "sudo systemctl enable logstash && sudo systemctl start logstash",
        "sudo systemctl enable filebeat && sudo systemctl start filebeat",
      ]
      startup_nodes_commands = []
    }
    k6 = {
      conf_logstash_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.logstash.conf.tpl", {}
      )
      conf_filebeat_file_content = templatefile(
        "${path.module}/scripts/jmeter.elk.filebeat.inputs.yml.tpl", {}
      )
      startup_leader_commands = [
        "sudo systemctl enable logstash && sudo systemctl start logstash",
        "sudo systemctl enable filebeat && sudo systemctl start filebeat",
      ]
      startup_nodes_commands = [
        "sudo systemctl enable logstash && sudo systemctl start logstash",
        "sudo systemctl enable filebeat && sudo systemctl start filebeat",
      ]

    }
  }
  default_exporter      = lookup(local.default_exporters, var.executor, {})
  exporter_leader_count = var.elastic_exporter.enable ? 1 : 0
  exporter_nodes_count  = var.elastic_exporter.enable ? var.nodes_size : 0
  conf_logstash_file_content = (
    var.elastic_exporter.custom ?
    var.elastic_exporter.conf_logstash_file_content :
    local.default_exporter.conf_logstash_file_content
  )
  conf_filebeat_file_content = (
    var.elastic_exporter.custom ?
    var.elastic_exporter.conf_filebeat_file_content :
    local.default_exporter.conf_filebeat_file_content
  )
  startup_leader_commands = (
    var.elastic_exporter.custom ?
    var.elastic_exporter.startup_leader_commands :
    local.default_exporter.startup_leader_commands
  )
  startup_nodes_commands = (
    var.elastic_exporter.custom ?
    var.elastic_exporter.startup_nodes_commands :
    local.default_exporter.startup_nodes_commands
  )
}

# Configure leader
resource "null_resource" "configure_exporter_on_leader" {
  count = local.exporter_leader_count
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
    inline = local.startup_leader_commands
  }
}

# Configure nodes
resource "null_resource" "configure_exporter_on_nodes" {
  count = local.exporter_nodes_count
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
    inline = local.startup_nodes_commands
  }
  provisioner "remote-exec" {
    inline = [
      "echo SETUP NODES ${count.index}",
      "sleep 1"
    ]
  }

}



#TODO:  Error: file provisioner error
#│
#│   with module.loadtest.null_resource.configure_exporter_on_leader[0],
#│   on ../../exporter.tf line 110, in resource "null_resource" "configure_exporter_on_leader":
#│  110:   provisioner "file" {
#│
#│ Upload failed: scp: /etc/filebeat: Permission denied
#╵
#╷
#│ Error: file provisioner error
#│
#│   with module.loadtest.null_resource.configure_exporter_on_nodes[0],
#│   on ../../exporter.tf line 138, in resource "null_resource" "configure_exporter_on_nodes":
#│  138:   provisioner "file" {
#│
#│ Upload failed: scp: /etc/filebeat/filebeat.yml: Permission denied
#╵
#╷
#│ Error: file provisioner error
#│
#│   with module.loadtest.null_resource.configure_exporter_on_nodes[1],
#│   on ../../exporter.tf line 138, in resource "null_resource" "configure_exporter_on_nodes":
#│  138:   provisioner "file" {
#│
#│ Upload failed: scp: /etc/filebeat/filebeat.yml: Permission denied

#provider "elasticsearch" {
#  url = "http://127.0.0.1:9200"
#}

# Create an index template
#resource "elasticsearch_index_template" "template_1" {
#  name = "template_1"
#  body = <<EOF
#{
#  "template": "te*",
#  "settings": {
#    "number_of_shards": 1
#  },
#  "mappings": {
#    "type1": {
#      "_source": {
#        "enabled": false
#      },
#      "properties": {
#        "host_name": {
#          "type": "keyword"
#        },
#        "created_at": {
#          "type": "date",
#          "format": "EEE MMM dd HH:mm:ss Z YYYY"
#        }
#      }
#    }
#  }
#}
#EOF
#}
