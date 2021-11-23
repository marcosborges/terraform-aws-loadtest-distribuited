# Elastic Exporter

The exporter's objective is to homogenize and to normalize the result provided by the loadtest executors and send them to an elastic search.

To perform this action the leader and load nodes are instrumented with **filebeat** to extract the results from the log files and **logstash** to homogenize and send the normalized data to elastic search.

---


## Basic usage

In the basic usage is necessary enable the elastic_exporter variable in the module definition.

When the exporter is enabled, the leader node will be instrumented with filebeat and the load nodes will be instrumented with logstash.

Will be used the default configuration for filebeat and logstash.

Finally, just provide your elastic search data such as: elastic_hostname, elastic_username, elastic_password and elastic_index.

```hcl
module "loadtest-jmeter" {
    source  = "marcosborges/loadtest-distribuited/aws"
    name = "nome-da-implantacao-basic"
    executor = "jmeter"
    loadtest_dir_source = "../plan/"
    nodes_size = 2
    loadtest_entrypoint = <<-EOT
        jmeter -n \
            -t jmeter/basic.jmx  \
            -R "{NODES_IPS}" \
            -l /var/logs/loadtest -e -o /var/www/html \
            -Dnashorn.args=--no-deprecation-warning \
            -Dserver.rmi.ssl.disable=true 
    EOT
    subnet_id = data.aws_subnet.current.id
    elastic_exporter = {
        enable = true
        elastic_hostname = "http://elastic-search-ip:9200"
        elastic_username = "elastic"
        elastic_password = "changeme"
        elastic_index = "loadtest-"
    }
}
```
The default configuration vary from one executor to another. You can find the default configuration at the `elastic_exporter`.

- ***JMeter***
    - [Filebeat default configuration](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/blob/master/scripts/jmeter.elk.filebeat.inputs.yml.tpl) 
    - [LogStash default configuration](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/blob/master/scripts/jmeter.elk.logstash.conf.tpl)


- ***Taurus***
    - [Filebeat default configuration](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/blob/master/scripts/jmeter.elk.filebeat.inputs.yml.tpl) 
    - [LogStash default configuration](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/blob/master/scripts/jmeter.elk.logstash.conf.tpl)


- ***Locust***
    - [Filebeat default configuration](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/blob/master/scripts/jmeter.elk.filebeat.inputs.yml.tpl) 
    - [LogStash default configuration](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/blob/master/scripts/jmeter.elk.logstash.conf.tpl)

---

## Customizing the elastic exporter

It is also possible to customize filebeat and logstash settings

To customize, just enable a custom flag and provide the content used to create the configuration file.



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
        custom = true
        conf_logstash_file_content = template(
            file("my.filebeat.inputs.yml.tpl")
        )
        conf_filebeat_file_content = template(
            file("my.filebeat.inputs.yml.tpl")
        )
        startup_leader_commands = ""
        startup_nodes_commands = ""
    }   
}

```

*For more details see the definition of variables in the [elastic_exporter](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/blob/master/variables.tf) section.*

---

## Normalized Summary

- **label** - is the sample group for which this CSV line presents the stats. Empty label means total of all labels
- **concurrency** - average number of Virtual Users
- **throughput** - total count of all samples
- **success** - total count of not-failed samples
- **failure** - total count of saved samples
- **avg_response_time** - average response time
- **stdev_response_time** - standard deviation of response time
- **avg_connect_time** - average connect time if present
- **avg_latency** - average latency if present
- **percentile_0.0 .. perc_100.0** - percentile levels for response time, 0 is also minimum response time, 100 is maximum
- **bytes** - total download size

---

## Setup the Dashboard

---


---
