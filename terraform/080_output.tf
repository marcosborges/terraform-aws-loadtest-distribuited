
output "nodes_ip_addr_public" {
  value = aws_instance.nodes.*.public_ip
}


output "nodes_ip_addr_private" {
  value = aws_instance.nodes.*.private_ip
}


output "master_ip_addr_public" {
  value = aws_instance.master.public_ip
}


output "master_ip_addr_private" {
  value = aws_instance.master.private_ip
}
