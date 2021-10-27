provider "aws" {
    region = "us-east-1"
}

module "loadtest" {

    source = "../../"

    name = "nome-da-implantacao"
    executor = "jmeter"
    loadtest_dir_source = "../plan"
    loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"
    nodes_size = 3

    subnet_id = data.aws_subnet.current.id
}

data "aws_subnet" "current" {
    filter {
        name   = "tag:Name"
        values = ["subnet-prd-a"]
    }
}