## ManAtWork

module "loadtest" {

    source = "../../"

    name = "nome-da-implantacao"
    executor = "jmeter"
    loadtest_dir_source = "../plan"
    loadtest_entrypoint = ""
    nodes_size = 3

    subnet_id = data.aws_subnet.current.id
}
