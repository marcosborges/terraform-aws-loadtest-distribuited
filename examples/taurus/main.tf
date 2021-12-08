module "loadtest" {

  source = "../../"

  name                = "nome-da-implantacao-taurus"
  executor            = "bzt"
  loadtest_dir_source = "../plan/"
  loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" taurus/*.yml"
  nodes_size          = 2

  subnet_id      = data.aws_subnet.current.id
  ssh_export_pem = false
}

data "aws_subnet" "current" {
  filter {
    name   = "tag:Name"
    values = ["subnet-prd-a"]
  }
}
