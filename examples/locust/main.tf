# ManAtWork

module "loadtest" {

    source = "../../"

    name = "nome-da-implantacao"
    executor = "locust"
    loadtest_dir_source = "../plan"
    loadtest_entrypoint = "locust --headless --master --workers=${var.node_size} --csv-output=locust.csv"
    nodes_size = var.node_size

    subnet_id = data.aws_subnet.current.id
}
