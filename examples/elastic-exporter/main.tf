module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name = "loadtest-vpc"
    cidr = "10.0.0.0/16"
    azs             = ["us-east-1a"]
    private_subnets = ["10.0.0.0/24"]
    public_subnets = ["10.0.1.0/24"]
    enable_nat_gateway = true
    enable_vpn_gateway = true
    tags = {
      costcenter =	"riachuelo-shared"
      environment =	"development"
      squad =	"squad-cloud"
    }
}

module "loadtest" {

  source = "../../"
  #source  = "marcosborges/loadtest-distribuited/aws"

  name                = "example-elastic-jmeter"
  executor            = "jmeter"
  loadtest_dir_source = "../plan/"
  nodes_size          = 2

  loadtest_entrypoint = <<-EOT
    jmeter \
      -n \
      -t jmeter/basic.jmx  \
      -R "{NODES_IPS}" \
      -l /loadtest/logs -e -o /var/www/html/jmeter \
      -Dnashorn.args=--no-deprecation-warning \
      -Dserver.rmi.ssl.disable=true
  EOT
  ssh_export_pem = true
  subnet_id      = module.vpc.private_subnets[0]

  elastic_exporter = {
      enable = true
      custom = true
      elastic_hostname =  "localhost" #aws_elasticsearch_domain.demo.endpoint
      elastic_username = "elastic"
      elastic_password = "changeme"
      elastic_index = "loadtest-"
      conf_logstash_file_content = ""
      conf_filebeat_file_content = ""
      startup_leader_commands    = []
      startup_nodes_commands     = []
  }

  tags = {
    costcenter =	"riachuelo-shared"
    environment =	"development"
    squad =	"cac"
  }
}

resource "aws_elasticsearch_domain" "demo" {
  domain_name           = "demo-loadtest"
  elasticsearch_version = "7.10"
  cluster_config {
    instance_type          = "m4.large.elasticsearch"
    zone_awareness_enabled = false
  }
  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }
  tags = {
    Domain = "TestDomain"
  }
  access_policies = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "es:*",
        "Principal": "*",
        "Effect": "Allow",
        "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/demo-loadtest/*",
        "Condition": {
          "IpAddress": {"aws:SourceIp": ["66.193.100.22/32"]}
        }
      }
    ]
  }
  POLICY

  # vpc_options {
  #   subnet_ids = [
  #     data.aws_subnet_ids.selected.ids[0],
  #     data.aws_subnet_ids.selected.ids[1],
  #   ]

  #   security_group_ids = [aws_security_group.es.id]
  # }

  # advanced_options = {
  #   "rest.action.multi.allow_explicit_index" = "true"
  # }
}



# resource "aws_security_group" "es" {
#   name        = "elasticsearch-loadtest"
#   description = "Managed by Terraform"
#   vpc_id      = data.aws_vpc.selected.id

#   ingress {
#     from_port = 443
#     to_port   = 443
#     protocol  = "tcp"

#     cidr_blocks = [
#       data.aws_vpc.selected.cidr_block,
#     ]
#   }
# }

# resource "aws_iam_service_linked_role" "es" {
#   aws_service_name = "es.amazonaws.com"
# }
