# AWS LoadTest Distribuited Terraform Module

This module proposes a simple and uncomplicated way to run your load tests created with JMeter or TaurusBzt on AWS as IaaS.


![bp](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/blueprint.png)


## Basic usage with JMeter

```hcl
module "loadtest-distribuited" {

    source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao"
    executor = "jmeter"
    loadtest_dir_source = "examples/plan/"
    nodes_size = 2

    loadtest_entrypoint = "jmeter -n -t jmeter/basic.jmx  -R \"{NODES_IPS}\" -l /var/logs/loadtest -e -o /var/www/html -Dnashorn.args=--no-deprecation-warning -Dserver.rmi.ssl.disable=true "

    subnet_id = data.aws_subnet.current.id
}

data "aws_subnet" "current" {
    filter {
        name   = "tag:Name"
        values = ["my-subnet-name"]
    }
}
```

![bp](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/example-basic.png)


![bp](https://github.com/marcosborges/terraform-aws-loadtest-distribuited/raw/master/assets/jmeter-dashboard.png)

---

## Basic usage with Taurus

In its basic use it is necessary to provide information about which network will be used, where are your test plan scripts and finally define the number of nodes needed to carry out the desired load.

```hcl
module "loadtest-distribuited" {

    source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao"
    executor = "jmeter"
    loadtest_dir_source = "examples/plan/"
    nodes_size = 2

    loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" taurus/basic.yml"

    subnet_id = data.aws_subnet.current.id
}

data "aws_subnet" "current" {
    filter {
        name   = "tag:Name"
        values = ["my-subnet-name"]
    }
}
```

---


## Advanced Config:

The module also provides advanced settings.

1. It is possible to automate the splitting of the contents of a bulk file between the load nodes.

2. It is possible to export the ssh key used in remote access.

3. We can define a pre-configured and customized image.

4. We can customize too many instances provisioning parameters: tags, monitoring, public_ip, security_group, etc...


```hcl
module "loadtest" {


    source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao"
    executor = "bzt"
    loadtest_dir_source = "examples/plan/"

    loadtest_dir_destination = "/loadtest"
    loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" taurus/basic.yml"
    nodes_size = 3


    subnet_id = data.aws_subnet.current.id

    #AUTO SPLIT
    split_data_mass_between_nodes = {
        enable = true
        data_mass_filenames = [
            "data/users.csv"
        ]
    }

    #EXPORT SSH KEY
    ssh_export_pem = true

    #CUSTOMIZE IMAGE
    leader_ami_id = data.aws_ami.my_image.id
    nodes_ami_id = data.aws_ami.my_image.id

    #CUSTOMIZE TAGS
    leader_tags = {
        "Name" = "nome-da-implantacao-leader",
        "Owner": "nome-do-proprietario",
        "Environment": "producao",
        "Role": "leader"
    }
    nodes_tags = {
        "Name": "nome-da-implantacao",
        "Owner": "nome-do-proprietario",
        "Environment": "producao",
        "Role": "node"
    }
    tags = {
        "Name": "nome-da-implantacao",
        "Owner": "nome-do-proprietario",
        "Environment": "producao"
    }

    # SETUP INSTANCE SIZE
    leader_instance_type = "t2.medium"
    nodes_intance_type = "t2.medium"

    # SETUP JVM PARAMETERS
    leader_jvm_args = " -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "
    nodes_jvm_args = " -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "

    # DISABLE AUTO SETUP
    auto_setup = false

    # SET JMETER VERSION. WORK ONLY WHEN AUTO-SETUP IS TRUE
    jmeter_version = "5.4.1"

    # ASSOCIATE PUBLIC IP
    leader_associate_public_ip_address = true
    nodes_associate_public_ip_address = true

    # ENABLE MONITORING
    leader_monitoring = true
    nodes_monitoring = true

    #  SETUP SSH USERNAME
    ssh_user = "ec2-user"

    # SETUP ALLOWEDs CIDRS FOR SSH ACCESS
    ssh_cidr_ingress_block = ["0.0.0.0/0"]

}

data "aws_subnet" "current" {
    filter {
        name   = "tag:Name"
        values = ["my-subnet-name"]
    }
}

data "aws_ami" "my_image" {
    most_recent = true
    filter {
        name   = "owner-alias"
        values = ["amazon"]
    }
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm*"]
    }
}

```
---

## Sugestion

The [C5](https://aws.amazon.com/pt/ec2/instance-types/c5/) family of instances is a good choice for the load test.


|Model|vCPU|Mem (GiB)|Storage (GiB)|Network Band. (Gbps)|
|:---:|:---:|:---:|:---:|:---:|
|c5n.large| 2 | 5.25	| EBS | 25 -> 4.750|
|c5n.xlarge| 4 | 10.5	| EBS | 25	-> 4.750|
|c5n.2xlarge| 8 | 21	| EBS | 25	-> 4.750|
|c5n.4xlarge| 16 | 42	| EBS | 25	4.750|
|c5n.9xlarge| 36 | 96   | EBS | 50	9.500|
|c5n.18xlarge| 72 | 192	| EBS | 100	19.000|
|c5n.metal| 72 | 192	| EBS | 100	19.000|

---


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.63 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.leader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.loadtest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [null_resource.executor](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.key_pair_exporter](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.publish_split_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.split_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.loadtest](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_execute"></a> [auto\_execute](#input\_auto\_execute) | Execute Loadtest after leader and nodes available | `bool` | `true` | no |
| <a name="input_auto_setup"></a> [auto\_setup](#input\_auto\_setup) | Install and configure instances Amazon Linux2 with JMeter and Taurus | `bool` | `true` | no |
| <a name="input_executor"></a> [executor](#input\_executor) | Executor of the loadtest | `string` | `"jmeter"` | no |
| <a name="input_jmeter_version"></a> [jmeter\_version](#input\_jmeter\_version) | JMeter version | `string` | `"5.4.1"` | no |
| <a name="input_leader_ami_id"></a> [leader\_ami\_id](#input\_leader\_ami\_id) | Id of the AMI | `string` | `""` | no |
| <a name="input_leader_associate_public_ip_address"></a> [leader\_associate\_public\_ip\_address](#input\_leader\_associate\_public\_ip\_address) | Associate public IP address to the leader | `bool` | `true` | no |
| <a name="input_leader_custom_setup_base64"></a> [leader\_custom\_setup\_base64](#input\_leader\_custom\_setup\_base64) | Custom bash script encoded in base64 to setup the leader | `string` | `""` | no |
| <a name="input_leader_instance_type"></a> [leader\_instance\_type](#input\_leader\_instance\_type) | Instance type of the cluster leader | `string` | `"t2.medium"` | no |
| <a name="input_leader_jvm_args"></a> [leader\_jvm\_args](#input\_leader\_jvm\_args) | JVM Leader JVM\_ARGS | `string` | `" -Xms2g -Xmx2g -XX:MaxMetaspaceSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "` | no |
| <a name="input_leader_monitoring"></a> [leader\_monitoring](#input\_leader\_monitoring) | Enable monitoring for the leader | `bool` | `true` | no |
| <a name="input_leader_tags"></a> [leader\_tags](#input\_leader\_tags) | Tags of the cluster leader | `map` | `{}` | no |
| <a name="input_loadtest_dir_destination"></a> [loadtest\_dir\_destination](#input\_loadtest\_dir\_destination) | Path to the destination loadtest directory | `string` | `"/loadtest"` | no |
| <a name="input_loadtest_dir_source"></a> [loadtest\_dir\_source](#input\_loadtest\_dir\_source) | Path to the source loadtest directory | `string` | n/a | yes |
| <a name="input_loadtest_entrypoint"></a> [loadtest\_entrypoint](#input\_loadtest\_entrypoint) | Path to the entrypoint command | `string` | `"bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the provision | `string` | n/a | yes |
| <a name="input_nodes_ami_id"></a> [nodes\_ami\_id](#input\_nodes\_ami\_id) | Id of the AMI | `string` | `""` | no |
| <a name="input_nodes_associate_public_ip_address"></a> [nodes\_associate\_public\_ip\_address](#input\_nodes\_associate\_public\_ip\_address) | Associate public IP address to the nodes | `bool` | `true` | no |
| <a name="input_nodes_custom_setup_base64"></a> [nodes\_custom\_setup\_base64](#input\_nodes\_custom\_setup\_base64) | Custom bash script encoded in base64 to setup the nodes | `string` | `""` | no |
| <a name="input_nodes_intance_type"></a> [nodes\_intance\_type](#input\_nodes\_intance\_type) | Instance type of the cluster nodes | `string` | `"t2.medium"` | no |
| <a name="input_nodes_jvm_args"></a> [nodes\_jvm\_args](#input\_nodes\_jvm\_args) | JVM Nodes JVM\_ARGS | `string` | `"-Xms2g -Xmx2g -XX:MaxMetaspaceSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 -Dnashorn.args=--no-deprecation-warning -XX:+HeapDumpOnOutOfMemoryError "` | no |
| <a name="input_nodes_monitoring"></a> [nodes\_monitoring](#input\_nodes\_monitoring) | Enable monitoring for the leader | `bool` | `true` | no |
| <a name="input_nodes_size"></a> [nodes\_size](#input\_nodes\_size) | Total number of nodes in the cluster | `number` | `2` | no |
| <a name="input_nodes_tags"></a> [nodes\_tags](#input\_nodes\_tags) | Tags of the cluster nodes | `map` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | Name of the region | `string` | `"us-east-1"` | no |
| <a name="input_split_data_mass_between_nodes"></a> [split\_data\_mass\_between\_nodes](#input\_split\_data\_mass\_between\_nodes) | Split data mass between nodes | <pre>object({<br>        enable = bool<br>        data_mass_filename = string<br>    })</pre> | <pre>{<br>  "data_mass_filename": "../plan/data/data.csv",<br>  "enable": false<br>}</pre> | no |
| <a name="input_ssh_cidr_ingress_blocks"></a> [ssh\_cidr\_ingress\_blocks](#input\_ssh\_cidr\_ingress\_blocks) | SSH user for the leader | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_ssh_export_pem"></a> [ssh\_export\_pem](#input\_ssh\_export\_pem) | n/a | `bool` | `false` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH user for the leader | `string` | `"ec2-user"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Id of the subnet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags | `map` | `{}` | no |
| <a name="input_taurus_version"></a> [taurus\_version](#input\_taurus\_version) | Taurus version | `string` | `"1.16.0"` | no |
| <a name="input_web_cidr_ingress_blocks"></a> [web\_cidr\_ingress\_blocks](#input\_web\_cidr\_ingress\_blocks) | web for the leader | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_leader_private_ip"></a> [leader\_private\_ip](#output\_leader\_private\_ip) | The private IP address of the leader server instance. |
| <a name="output_leader_public_ip"></a> [leader\_public\_ip](#output\_leader\_public\_ip) | The public IP address of the leader server instance. |
| <a name="output_nodes_private_ip"></a> [nodes\_private\_ip](#output\_nodes\_private\_ip) | The private IP address of the nodes instances. |
| <a name="output_nodes_public_ip"></a> [nodes\_public\_ip](#output\_nodes\_public\_ip) | The public IP address of the nodes instances. |
<!-- END_TF_DOCS -->
