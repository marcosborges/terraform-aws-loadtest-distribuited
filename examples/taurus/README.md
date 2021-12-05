# Taurus Basic Configuration

In its basic use it is necessary to provide information about which network will be used, where are your test plan scripts and finally define the number of nodes needed to carry out the desired load.

```hcl
module "loadtest" {

    source = "../../"

    name = "nome-da-implantacao-taurus"
    executor = "bzt"
    loadtest_dir_source = "../plan/"
    loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" taurus/*.yml"
    nodes_size = 2

    subnet_id = data.aws_subnet.current.id
}

data "aws_subnet" "current" {
    filter {
        name   = "tag:Name"
        values = ["subnet-prd-a"]
    }
}
```

---
