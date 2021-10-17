

# resource "aws_subnet" "my_subnet" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "172.16.10.0/24"
#   availability_zone = "us-west-2a"

#   tags = {
#     Name = "tf-example"
#   }
# }


#module "vpc" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "3.8.0"
#  
#  name = "vpc"
#  cidr = "10.0.0.0/16"
#
#  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
#
#  enable_nat_gateway = true
#  enable_vpn_gateway = true
#
#  tags = {
#    Terraform = "true"
#    Environment = "dev"
#  }
#}