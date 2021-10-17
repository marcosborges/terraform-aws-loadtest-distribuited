
data "aws_ami" "ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name]
  }
  owners = ["self"] # Canonical

}