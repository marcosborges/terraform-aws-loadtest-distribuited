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


data "aws_ami" "amazon-linux-2" {
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
    name = "nome-da-implantacao"
    loadtest_dir_source = "./assets"
    loadtest_dir_destination = "/loadtest"
    vpc_id = data.aws_vpcs.current.id
    subnet_id = data.aws_subnets.current.id
    leader_ami_id = ""
    leader_instance_type = "t2.medium"
    leader_tags = {
        "Name" = "nome-da-implantacao-leader",
        "Owner": "nome-do-proprietario",
        "Environment": "producao",
        "Role": "leader"
    }
    nodes_total = 3
    nodes_ami_id = ""
    nodes_intance_type = "t2.medium"
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