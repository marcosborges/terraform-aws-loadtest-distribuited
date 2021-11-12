# Using Locust in distributed mode
    
In its basic use it is necessary to provide information about which network will be used, where are your test plan scripts and finally define the number of nodes needed to carry out the desired load.

```hcl
module "loadtest-distribuited" {
    
    source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao-locust"
    nodes_size = var.node_size
    executor = "locust"
    loadtest_dir_source = "../plan/"
    
    # LEADER ENTRYPOINT
    loadtest_entrypoint = <<-EOT
        nohup locust \
            -f ${var.locust_plan_filename} \
            --web-port=8080 \
            --expect-workers=${var.node_size} \
            --master > locust-leader.out 2>&1 &
    EOT
    
    # NODES ENTRYPOINT
    node_custom_entrypoint = <<-EOT
        nohup locust \
            -f ${var.locust_plan_filename} \
            --worker \
            --master-host={LEADER_IP} > locust-worker.out 2>&1 &
    EOT

    subnet_id = data.aws_subnet.current.id
    locust_plan_filename = var.locust_plan_filename
}

variable "node_size" {
    description = "Size of total nodes"
    default = 2
}

variable "locust_plan_filename" {
    default = "locust/basic.py"
}
```
---

[Locust distributed doc.](https://docs.locust.io/en/latest/running-locust-distributed.html)


---

![result](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/locust-execution-result.png) 


![home](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/locust-home.png) 


![chart](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/locust-chart.png) 


![workers](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/locust-workers.png) 


---
