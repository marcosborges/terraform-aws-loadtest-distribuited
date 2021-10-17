
resource "aws_security_group" "jmeter" {
  name        = "seg-${var.tenant_id}-${var.plan_id}-${var.plan_execution_id}"
  
  description = "Allow inbound traffic for Jmeter"
  vpc_id      = var.vpc_id

  ingress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "seg-${var.tenant_id}-${var.plan_id}-${var.plan_execution_id}"
    SC_PLAN_ID = var.plan_id
    SC_PLAN_NAME = var.plan_name
    SC_PLAN_EXECUTION_ID = var.plan_execution_id
    SC_PLAN_EXECUTION_AUTHOR = var.plan_execution_author
    SC_TENANT_ID = var.tenant_id
  }
}


resource "aws_iam_role" "sc_jmeter_role" {
  name = "sc_jmeter_role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "202110011659"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name = "sc_jmeter_opensearch_inline_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["es:ESHttp*"]
          Effect   = "Allow"
          Resource = "arn:aws:es:us-east-1:303011076276:domain/sobre-carga/*"
        },
      ]
    })
  }
  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_instance_profile" "sc_instances_profile" {
  name = "sc_instances_profile"
  role = aws_iam_role.sc_jmeter_role.name
}


resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "loader" {
  key_name   = "${var.tenant_id}-${var.plan_id}-${var.plan_execution_id}"
  public_key =  tls_private_key.private_key.public_key_openssh
  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ./${var.tenant_id}-${var.plan_id}-${var.plan_execution_id}.pem"
  }
}

