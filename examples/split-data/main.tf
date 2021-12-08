module "loadtest" {

  source = "../../"
  #source  = "marcosborges/loadtest-distribuited/aws"

  name                = "nome-da-implantacao-spliter"
  executor            = "jmeter"
  loadtest_dir_source = "../plan/"
  nodes_size          = 2

  loadtest_entrypoint = "jmeter -n -t jmeter/basic-with-data.jmx  -R \"{NODES_IPS}\" -l /loadtest/logs -e -o /var/www/html/jmeter -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true -LDEBUG "

  split_data_mass_between_nodes = {
    enable = true
    data_mass_filenames = [
      "data/users.csv"
    ]
  }

  subnet_id = data.aws_subnet.current.id

  ssh_export_pem = true
}
