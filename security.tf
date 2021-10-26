
resource "aws_security_group" "jmeter" {
    
    name = "${var.name}-jmeter-seg"
    
    description = "Allow inbound traffic for Jmeter"
    
    vpc_id  = data.aws_vpc.current.id

    ingress {
        description = "JMeter Server Port"
        from_port   = 1099
        to_port     = 1099
        protocol    = "TCP"
        cidr_blocks      = [data.aws_vpc.current.cidr_block]
    }

    ingress {
        description = "JMeter RMI Server Port"
        from_port   = 50000
        to_port     = 50000
        protocol    = "TCP"
        cidr_blocks      = [data.aws_vpc.current.cidr_block]
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
            "Name": "${var.name}-jmeter-seg"
        }
    )

}

resource "aws_iam_role" "jmeter" {
    name = "${var.name}-jmeter-role"

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
            "Name": "${var.name}-jmeter-role"
        }
    )
}

resource "aws_iam_instance_profile" "jmeter" {
    name = "${var.name}-jmeter-profile"
    role = aws_iam_role.jmeter.name
}

resource "tls_private_key" "jmeter" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "jmeter" {
    key_name   = "${var.name}-jmeter-keypair"
    public_key =  tls_private_key.jmeter.public_key_openssh
    provisioner "local-exec" {
        command = "echo '${tls_private_key.jmeter.private_key_pem}' > ${var.name}-keypair"
    }
}
