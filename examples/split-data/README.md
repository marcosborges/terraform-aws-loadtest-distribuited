# Split data between nodes
    
The implementation for dividing the data mass file between the load executing nodes aims to uncomplicate this existing friction in the execution of distributed load tests;

Is very simple to activate this option.

Just set the `split_data_mass_between_nodes` variable by activating the feature and informing your mass data files to be distributed.

See the example below...

```hcl
module "loadtest" {

    source  = "marcosborges/loadtest-distribuited/aws"
    
    name = "nome-da-implantacao"
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

Behind the scene the terraform script sends all data mass files to the payload leader.

![split](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/feat/spliter/assets/split-cmd.png)

After submission, the files are divided by the leader into fragments by us.

![split-result](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/feat/spliter/assets/split-cmd-result.png)

The last action is to send each fragment to its respective node.

![split-result](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/feat/spliter/assets/split-transfer.png)


Splitting the files uses the linux `split` command and splits the main file into 1 fragment for each node.

![split-result](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/feat/spliter/assets/split-transfer.png)

More info: [Split doc](https://man7.org/linux/man-pages/man1/split.1.html)

---