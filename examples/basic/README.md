# Basic Config:
    
In its basic use it is necessary to provide information about which network will be used, where are your test plan scripts and finally define the number of nodes needed to carry out the desired load.

```hcl
module "loadtest-distribuited" {

    source = "../../"
    #source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao-basic"
    executor = "jmeter"
    loadtest_dir_source = "../plan/"
    nodes_size = 2
    
    loadtest_entrypoint = "jmeter -n -t jmeter/basic.jmx  -R \"{NODES_IPS}\" -l /var/logs/loadtest -e -o /var/www/html -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true "

    subnet_id = data.aws_subnet.current.id
}
```


![bp](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/example-basic.png) 


![bp](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/jmeter-dashboard.png) 


---
