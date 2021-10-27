# Basic Config:
    
In its basic use it is necessary to provide information about which network will be used, where are your test plan scripts and finally define the number of nodes needed to carry out the desired load.

```hcl
module "loadtest" {

    source  = "marcosborges/loadtest-distribuited/aws"
    version = "0.0.3-alpha"
  
    name = "nome-da-implantacao"
    executor = "bzt"
    loadtest_dir_source = "./assets"
    loadtest_dir_destination = "/loadtest"
    loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"
    nodes_size = 3

    subnet_id = data.aws_subnet.current.id

}

data "aws_subnet" "current" {
    filter {
        name   = "tag:Name"
        values = ["my-subnet-name"]
    }
}
```