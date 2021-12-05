module "loadtest" {
    source = "../../"
    #source  = "marcosborges/loadtest-distribuited/aws"
    #version = "1.0.0"
    name = "nome-da-implantacao"
    executor = var.executor
    loadtest_dir_source = "../plan"
    nodes_size = 2
    loadtest_entrypoint = "jmeter -n -t jmeter/*.jmx  -R \"{NODES_IPS}\" -l /loadtest/logs -e -o /var/www/html/jmeter -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true"
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
