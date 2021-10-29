module "loadtest" {

    source = "../../"

    name = "nome-da-implantacao"
    executor = "jmeter"
    loadtest_dir_source = "../plan"
    nodes_size = 2
    
    #loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"
    loadtest_entrypoint = "jmeter -n -t *.jmx  -R \"{NODES_IPS}\" -l ./logs -e -o ./results -Dserver.rmi.localport=50000 -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$PRIVATE_IP"
    #loadtest_entrypoint = "jmeter -n -t *.jmx -R \"{NODES_IPS}\" -l ./logs -e -o ./results "

    ssh_export_pem = true

    subnet_id = module.vpc.private_subnets[0].id

}


module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name = "my-vpc"
    cidr = "10.0.0.0/16"
    azs             = ["us-east-1a"]
    private_subnets = ["10.0.1.0/24"]
    enable_nat_gateway = true
    enable_vpn_gateway = true
    tags = {
        Terraform = "true"
        Environment = "load-test"
    }
}