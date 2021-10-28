module "loadtest" {

    source = "../../"

    name = "nome-da-implantacao"
    executor = "jmeter"
    loadtest_dir_source = "../plan"
    nodes_size = 2
    
    #loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"
    loadtest_entrypoint = "jmeter -n -t -R \"{NODES_IPS}\" *.jmx -l ./logs -e -o ./results"
    #loadtest_entrypoint = "jmeter -n -t *.jmx -R \"{NODES_IPS}\" -l ./logs -e -o ./results -Dserver.rmi.localport=50000 -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$PRIVATE_IP"

    ssh_export_pem = true

    subnet_id = data.aws_subnet.current.id
}

