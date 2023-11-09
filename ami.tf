locals {
  leader_ami_id = var.leader_ami_id == "" ? data.aws_ami.amazon_linux_2.id : var.leader_ami_id
  nodes_ami_id  = var.nodes_ami_id == "" ? data.aws_ami.amazon_linux_2.id : var.nodes_ami_id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
