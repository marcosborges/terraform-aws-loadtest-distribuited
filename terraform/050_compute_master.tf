
locals {
  node_ips = "['${join("','",aws_instance.nodes.*.private_ip)}']"
}

resource "aws_instance" "master" {
  ami = data.aws_ami.ami.id
  associate_public_ip_address = true
  instance_type = var.instance_type_master
  vpc_security_group_ids      = [aws_security_group.jmeter.id]
  user_data_base64 = base64encode(local.master_user_data)
  key_name = aws_key_pair.loader.key_name
  monitoring = true
  tags = {
    Name = "ec2-${var.tenant_id}-${var.plan_id}-${var.plan_execution_id}-master"
    SC_PLAN_ID = var.plan_id
    SC_PLAN_NAME = var.plan_name
    SC_PLAN_EXECUTION_ID = var.plan_execution_id
    SC_PLAN_EXECUTION_AUTHOR = var.plan_execution_author
    SC_TENANT_ID = var.tenant_id
  }
  subnet_id = "subnet-0190fb80f3f79f0ca"
  iam_instance_profile = aws_iam_instance_profile.sc_instances_profile.name

   # Copies the configs.d folder to /etc/configs.d
  provisioner "file" {
    source      = "../../assets"
    destination = "/bzt-configs/"
  }

  provisioner "file" {
    destination = "/bzt-configs/"
    source      = "../../src/taurus/"
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.private_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      #"while [ ! -f /var/lib/apache-jmeter-5.3/bin/jmeter ]; do sleep 10; done",
      "echo bzt -q -o execution.0.distributed=\"${local.node_ips}\" site/*.yml",
      "cd /bzt-configs",
      #"nohup bzt -q -o execution.0.distributed=\"${local.node_ips}\" site/*.yml",
    ]
  }

}
