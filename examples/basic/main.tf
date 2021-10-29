module "loadtest" {

    source = "../../"
    #source  = "marcosborges/loadtest-distribuited/aws"
    #version = "0.0.8-alpha"

    name = "nome-da-implantacao"
    executor = "jmeter"
    loadtest_dir_source = "../plan/"
    nodes_size = 2
    
    loadtest_entrypoint = "jmeter -n -t jmeter/*.jmx  -R \"{NODES_IPS}\" -l /var/logs/loadtest -e -o /var/www/html -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true "

    ssh_export_pem = true
    subnet_id = data.aws_subnet.current.id
}

