# Elastic Exporter:

The exporter's objective is to homogenize the result provided by the loadtest executors and send them to an elastic search.

To perform this action the leader and load nodes are instrumented with filebeat to extract the results from the log files and logstash to homogenize and send the normalized data to elastic search.

---

## Basic usage

```hcl
module "loadtest-jmeter" {
    source  = "marcosborges/loadtest-distribuited/aws"
    name = "nome-da-implantacao-basic"
    executor = "jmeter"
    loadtest_dir_source = "../plan/"
    nodes_size = 2
    loadtest_entrypoint = "jmeter -n -t jmeter/basic.jmx  -R \"{NODES_IPS}\" -l /var/logs/loadtest -e -o /var/www/html -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true "
    subnet_id = data.aws_subnet.current.id

    elastic_exporter = {
        enable = true
    }
}
```
---

## Customizing the elastic exporter

```hcl
module "loadtest-locust" {
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

    elastic_exporter = {
        enable = true
        conf_logstash_file_content = template(
            file("my.filebeat.inputs.yml.tpl")
        )
        conf_filebeat_file_content = template(
            file("my.filebeat.inputs.yml.tpl")
        )
    }   
}

```
---


![bp](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/jmeter-dashboard.png) 


---
