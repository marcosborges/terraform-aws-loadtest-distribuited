# AWS LoadTest Distribuited Terraform Module

This module is used to create and manage AWS Jmeter/Taurus LoadTest Distributed.

## JMeter basic usage

```hcl

data "aws_vpcs" "current" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

data "aws_subnets" "current" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_name}"]
  }
}

module "loadtest" {
    source = ""
    name = "my-loadtest"
    vpc_id = data.aws_vpcs.current
    subnet_id = data.aws_subnets.current
    
    loadtest_entrypoint='bzt -q -o execution.0.distributed=\"${local.node_ips}\" site/*.yml'
    



}

```

---

## Taurus basic usage

```hcl
module "loadtest" {
    source = ""
    name = "my-loadtest"
    

    
}

```

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
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.jmeter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.jmeter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.leader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.jmeter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.jmeter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [tls_private_key.jmeter](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_subnets.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpcs.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_executor"></a> [executor](#input\_executor) | Executor of the loadtest | `string` | `"jmeter"` | no |
| <a name="input_leader_ami_id"></a> [leader\_ami\_id](#input\_leader\_ami\_id) | Id of the AMI | `string` | n/a | yes |
| <a name="input_leader_associate_public_ip_address"></a> [leader\_associate\_public\_ip\_address](#input\_leader\_associate\_public\_ip\_address) | Associate public IP address to the leader | `bool` | `true` | no |
| <a name="input_leader_instance_type"></a> [leader\_instance\_type](#input\_leader\_instance\_type) | Instance type of the cluster leader | `string` | `"t2.medium"` | no |
| <a name="input_leader_monitoring"></a> [leader\_monitoring](#input\_leader\_monitoring) | Enable monitoring for the leader | `bool` | `true` | no |
| <a name="input_leader_ssh_user"></a> [leader\_ssh\_user](#input\_leader\_ssh\_user) | SSH user for the leader | `string` | `"ec2-user"` | no |
| <a name="input_leader_tags"></a> [leader\_tags](#input\_leader\_tags) | Tags of the cluster leader | `map` | n/a | yes |
| <a name="input_loadtest_dir_destination"></a> [loadtest\_dir\_destination](#input\_loadtest\_dir\_destination) | Path to the destination loadtest directory | `string` | `"/loadtest"` | no |
| <a name="input_loadtest_dir_source"></a> [loadtest\_dir\_source](#input\_loadtest\_dir\_source) | Path to the source loadtest directory | `string` | n/a | yes |
| <a name="input_loadtest_entrypoint"></a> [loadtest\_entrypoint](#input\_loadtest\_entrypoint) | Path to the entrypoint command | `string` | `"bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the provision | `string` | n/a | yes |
| <a name="input_nodes_ami_id"></a> [nodes\_ami\_id](#input\_nodes\_ami\_id) | Id of the AMI | `string` | n/a | yes |
| <a name="input_nodes_associate_public_ip_address"></a> [nodes\_associate\_public\_ip\_address](#input\_nodes\_associate\_public\_ip\_address) | Associate public IP address to the nodes | `bool` | `true` | no |
| <a name="input_nodes_intance_type"></a> [nodes\_intance\_type](#input\_nodes\_intance\_type) | Instance type of the cluster nodes | `string` | `"t2.medium"` | no |
| <a name="input_nodes_monitoring"></a> [nodes\_monitoring](#input\_nodes\_monitoring) | Enable monitoring for the leader | `bool` | `true` | no |
| <a name="input_nodes_ssh_user"></a> [nodes\_ssh\_user](#input\_nodes\_ssh\_user) | SSH user for the leader | `string` | `"ec2-user"` | no |
| <a name="input_nodes_tags"></a> [nodes\_tags](#input\_nodes\_tags) | Tags of the cluster nodes | `map` | n/a | yes |
| <a name="input_nodes_total"></a> [nodes\_total](#input\_nodes\_total) | Total number of nodes in the cluster | `number` | `2` | no |
| <a name="input_region"></a> [region](#input\_region) | Name of the region | `string` | `"us-east-1"` | no |
| <a name="input_setup_instance"></a> [setup\_instance](#input\_setup\_instance) | Install and configure instances Amazon Linux2 with JMeter and Taurus | `bool` | `true` | no |
| <a name="input_setup_instance_jmeter_version"></a> [setup\_instance\_jmeter\_version](#input\_setup\_instance\_jmeter\_version) | JMeter version | `string` | `"5.4.1"` | no |
| <a name="input_setup_instance_leader_jmeter_opts"></a> [setup\_instance\_leader\_jmeter\_opts](#input\_setup\_instance\_leader\_jmeter\_opts) | JMeter Leader OPTS | `string` | `" -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "` | no |
| <a name="input_setup_instance_nodes_jmeter_opts"></a> [setup\_instance\_nodes\_jmeter\_opts](#input\_setup\_instance\_nodes\_jmeter\_opts) | JMeter Nodes OPTS | `string` | `" -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "` | no |
| <a name="input_setup_instance_taurus_version"></a> [setup\_instance\_taurus\_version](#input\_setup\_instance\_taurus\_version) | Taurus version | `string` | `"1.16.0"` | no |
| <a name="input_ssh_cird_ingress_blocks"></a> [ssh\_cird\_ingress\_blocks](#input\_ssh\_cird\_ingress\_blocks) | SSH user for the leader | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Id of the subnet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags | `map` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_leader_private_ip"></a> [leader\_private\_ip](#output\_leader\_private\_ip) | The private IP address of the leader server instance. |
| <a name="output_leader_public_ip"></a> [leader\_public\_ip](#output\_leader\_public\_ip) | The public IP address of the leader server instance. |
| <a name="output_nodes_private_ip"></a> [nodes\_private\_ip](#output\_nodes\_private\_ip) | The private IP address of the nodes instances. |
| <a name="output_nodes_public_ip"></a> [nodes\_public\_ip](#output\_nodes\_public\_ip) | The public IP address of the nodes instances. |
<!-- END_TF_DOCS -->