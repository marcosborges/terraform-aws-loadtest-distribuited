# Basic Config:
    
In its basic use it is necessary to provide information about which network will be used, where are your test plan scripts and finally define the number of nodes needed to carry out the desired load.

```hcl
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
```

---
