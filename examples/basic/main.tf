module "loadtest" {

    source = "../../"
    #source  = "marcosborges/loadtest-distribuited/aws"
    #version = "1.0.0"

    name = "nome-da-implantacao"
    executor = var.executor #"jmeter"
    loadtest_dir_source = "../plan/"
    nodes_size = 2
    
    loadtest_entrypoint = "jmeter -n -t jmeter/basic.jmx  -R \"{NODES_IPS}\" -l /loadtest/logs -e -o /var/www/html/jmeter -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true "

    ssh_export_pem = true
    subnet_id = data.aws_subnet.current.id
}