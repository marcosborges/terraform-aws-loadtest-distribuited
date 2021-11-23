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
  subnet_id      = data.aws_subnet.current.id
}

resource "aws_elasticsearch_domain" "example" {
  domain_name           = "example"
  elasticsearch_version = "7.10"
  cluster_config {
    instance_type = "r4.large.elasticsearch"
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
        "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${self.domain_name}/*",
        "Condition": {
          "IpAddress": {"aws:SourceIp": ["66.193.100.22/32"]}
        }
      }
    ]
  }
  POLICY
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}