data "aws_vpcs" "current" {
    filter {
        name   = "tag:Name"
        values = ["my-vpc-name"]
    }
}


data "aws_subnets" "current" {
    filter {
        name   = "tag:Name"
        values = ["my-subnet-name"]
    }
}


data "aws_vpcs" "current" {
    filter {
        name   = "tag:Name"
        values = ["my-vpc-name"]
    }
}


data "aws_ami" "amazon_linux_2" {
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


module "loadtest" {
    source = "../../"

    vpc_id = data.aws_vpcs.current.id
    subnet_id = data.aws_subnets.current.id

    name = "nome-da-implantacao"

    executor = "jmeter"
    loadtest_dir_source = "./assets"
    loadtest_dir_destination = "/loadtest"
    loadtest_entrypoint = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"
    
    leader_instance_type = "t2.medium"
    setup_instance_leader_jmeter_opts = " -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "
    leader_ami_id = data.aws_ami.amazon_linux_2.id

    leader_tags = {
        "Name" = "nome-da-implantacao-leader",
        "Owner": "nome-do-proprietario",
        "Environment": "producao",
        "Role": "leader"
    }

    nodes_total = 3
    nodes_ami_id = data.aws_ami.amazon_linux_2.id
    nodes_intance_type = "t2.medium"
    setup_instance_nodes_jmeter_opts = " -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "
 
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
}

variable "assume_role_enable" {
    default = false
    type = bool
}

variable "assume_role_arn" {
    default = ""
    type = string
}

variable "assume_role_external_id" {
    default = ""
    type = string
}

terraform {
    #backend "s3" {}
}

provider "aws" {
    region = var.region
    dynamic "assume_role" {
        for_each = var.assume_role_enable ? [true] : []
        content {
            role_arn    =  var.assume_role_arn
            external_id =  var.assume_role_external_id
        }
    }
}


