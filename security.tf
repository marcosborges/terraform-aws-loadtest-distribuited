resource "aws_security_group" "loadtest" {
    
    name = "${var.name}-loadtest-seg"
    
    description = "Allow inbound traffic for Jmeter"
    
    vpc_id  = data.aws_vpc.current.id

    ingress {
        description = "JMeter Server Port"
        from_port   = 1099
        to_port     = 1099
        protocol    = "TCP"
        cidr_blocks = [data.aws_vpc.current.cidr_block]
    }

    ingress {
        description = "JMeter RMI Server Port"
        from_port   = 50000
        to_port     = 50000
        protocol    = "TCP"
        cidr_blocks = [data.aws_vpc.current.cidr_block]
    }

    ingress {
        description = "port 22"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.ssh_cidr_ingress_block
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
        {
            "Name": "${var.name}-loadtest-seg"
        }
    )

}

resource "aws_iam_role" "loadtest" {
    name = "${var.name}-loadtest-role"

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

    tags = merge(
        var.tags,
        {
            "Name": "${var.name}-loadtest-role"
        }
    )
}

resource "aws_iam_instance_profile" "loadtest" {
    name = "${var.name}-loadtest-profile"
    role = aws_iam_role.loadtest.name
}

resource "tls_private_key" "loadtest" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

locals {
    export_pem_cmd = var.ssh_export_pem == true ? "echo '${tls_private_key.loadtest.private_key_pem}' > ${var.name}-keypair.pem" : "echo 'no exported'"
}

resource "aws_key_pair" "loadtest" {
    key_name   = "${var.name}-loadtest-keypair"
    public_key =  tls_private_key.loadtest.public_key_openssh
    provisioner "local-exec" {
        command = local.export_pem_cmd
    }
}
