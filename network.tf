
data "aws_vpcs" "current" {
    id = var.vpc_id
}

data "aws_subnets" "current" {
    id = var.subnet_id
}