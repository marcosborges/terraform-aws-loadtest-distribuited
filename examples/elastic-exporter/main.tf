module "loadtest" {

    source = "../../"
    #source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao-basic"
    executor = var.executor #"jmeter"
    loadtest_dir_source = "../plan/"
    nodes_size = 2
    
    loadtest_entrypoint = "jmeter -n -t jmeter/basic.jmx  -R \"{NODES_IPS}\" -l /loadtest/logs -e -o /var/www/html/jmeter -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true "

    ssh_export_pem = false
    subnet_id = data.aws_subnet.current.id
}