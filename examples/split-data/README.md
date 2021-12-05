# Split data between nodes

The implementation for dividing the data mass file between the load executing nodes aims to uncomplicate this existing friction in the execution of distributed load tests;

Is very simple to activate this option.

Just set the `split_data_mass_between_nodes` variable by activating the feature and informing your mass data files to be distributed.

See the example below...

## Example

```hcl
module "loadtest" {

    source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao-spliter"
    executor = "jmeter"
    loadtest_dir_source = "../plan/"
    nodes_size = 2

    loadtest_entrypoint = "jmeter -n -t jmeter/basic-with-data.jmx  -R \"{NODES_IPS}\" -l /loadtest/logs -e -o /var/www/html/jmeter -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true -LDEBUG "

    split_data_mass_between_nodes = {
        enable = true
        data_mass_filenames = [
            "data/users.csv"
        ]
    }

    subnet_id = data.aws_subnet.current.id
}
```
---

## Behind the scene:

1. sends all data mass files to the leader.

![split](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/split-cmd.png)

2. After submission, the files are divided by the leader into fragments by us for each nodes.

![split-result](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/split-cmd-result.png)

3. The last action is to send each fragment to its respective node.

![split-result](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/split-transfer.png)

*Splitting the files uses the linux `split` command and splits the main file into 1 fragment for each node.*

More info: [Split doc](https://man7.org/linux/man-pages/man1/split.1.html)

---
